# Runbook – IPv6 Migration with OSPFv3 & NAT-PT

> Example addressing only: IPv6 block `2001:db8:acad::/48` (documentation prefix), IPv4 `198.51.100.0/24`.

---

## 1. IPv6 Address Plan

Use a **/64 per network** (best practice). Encode the site or link in the 4th hextet so it's easy to read.

| Network | Prefix | Router | Hosts |
|---|---|---|---|
| HQ LAN | 2001:db8:acad:1::/64 | ::1 | PC ::10, Server ::100 |
| Branch A LAN | 2001:db8:acad:2::/64 | ::1 | PC ::10, Server ::100 |
| Branch B LAN | 2001:db8:acad:3::/64 | ::1 | PC ::10, Server ::100 |
| HQ ↔ Branch A | 2001:db8:acad:12::/64 | HQ ::1, A ::2 | – |
| HQ ↔ Branch B | 2001:db8:acad:13::/64 | HQ ::1, B ::2 | – |
| Branch A ↔ Branch B | 2001:db8:acad:23::/64 | A ::1, B ::2 | – |
| NAT-PT prefix | 2001:db8:ffff::/96 | HQ | – |

## 2. IPv4 Address Plan (legacy branch)

| Network | Prefix | Addresses |
|---|---|---|
| Branch C LAN | 198.51.100.0/25 | Router .1, PC .2, Server .100 |
| HQ ↔ Branch C | 198.51.100.128/30 | Branch C .129, HQ .130 |

---

## 3. Build Order

1. **Addressing:** configure every interface (`ipv6 address` / `ip address`, `no shutdown`)
2. **IPv6 routing:** `ipv6 unicast-routing` on HQ, A and B
3. **OSPFv3:** `ipv6 router ospf 1` + `router-id x.x.x.x`, then `ipv6 ospf 1 area 0` on each IPv6 interface
4. **OSPFv2:** `router ospf 1` on HQ and Branch C for the /30 and the Branch C LAN
5. **NAT-PT on HQ:** `ipv6 nat` on the IPv6 LAN and the IPv4 link, static mappings each way, `ipv6 nat prefix`
6. **Hosts:** IPv6 hosts use the router's link address as their gateway, and IPv4 hosts use 198.51.100.1

Configs: [`configs/`](configs/)

---

## 4. Verification Checklist

| Test | Command | Expected |
|---|---|---|
| IPv6 site to site | `ping 2001:db8:acad:3::10` from Branch A | Replies |
| OSPFv3 adjacencies | `show ipv6 ospf neighbor` on HQ | FULL with A and B |
| OSPFv2 adjacency | `show ip ospf neighbor` on HQ | FULL with Branch C |
| IPv6 → IPv4 server | `ping 2001:db8:ffff::c633:6464` (mapped address) | Replies via NAT-PT |
| IPv4 → IPv6 server | `ping` the IPv4 alias of the HQ server | Replies via NAT-PT |
| Path | `tracert` from Branch C | Goes through HQ |
| Translations | `show ipv6 nat translations` | Static entries + ICMP sessions |
