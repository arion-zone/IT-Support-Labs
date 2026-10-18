# Runbook – Multi-Building Campus Network

> Example addressing only: campus block `10.20.0.0/16`, ISP link `203.0.113.0/30`.

---

## 1. VLSM Plan

Rule: allocate the **largest** subnet first. Each subnet needs hosts + 3 addresses (network, broadcast and gateway), plus room for the two HSRP routers.

| VLAN | Department (example) | Hosts needed | Prefix | Network | Virtual GW (HSRP) | Core-1 / Core-2 | Usable hosts | Broadcast |
|---|---|---|---|---|---|---|---|---|
| 10 | Sales | 180 | /24 | 10.20.0.0 | 10.20.0.1 | .2 / .3 | .4 – .254 | 10.20.0.255 |
| 20 | Operations | 90 | /25 | 10.20.1.0 | 10.20.1.1 | .2 / .3 | .4 – .126 | 10.20.1.127 |
| 30 | Finance | 90 | /25 | 10.20.1.128 | 10.20.1.129 | .130 / .131 | .132 – .254 | 10.20.1.255 |
| 40 | Engineering | 50 | /26 | 10.20.2.0 | 10.20.2.1 | .2 / .3 | .4 – .62 | 10.20.2.63 |
| 50 | HR | 20 | /27 | 10.20.2.64 | 10.20.2.65 | .66 / .67 | .68 – .94 | 10.20.2.95 |
| – | Core-1 ↔ Gateway | 2 | /30 | 10.20.2.96 | – | .98 (core) / .97 (gw) | – | 10.20.2.99 |
| – | Core-2 ↔ Gateway | 2 | /30 | 10.20.2.100 | – | .102 (core) / .101 (gw) | – | 10.20.2.103 |
| – | Gateway ↔ ISP | 2 | /30 | 203.0.113.0 | – | .2 (gw) / .1 (ISP) | – | 203.0.113.3 |

Quick check: a /24 gives 254 usable addresses, a /25 gives 126, a /26 gives 62 and a /27 gives 30.

---

## 2. Access Switches (each building)

- Create the VLANs, set user/phone ports as **access** ports, and set the uplinks to both cores as **trunks**.
- Use the same template on every access switch and change only the VLAN IDs.
- Config: [`configs/access-switch.txt`](configs/access-switch.txt)

## 3. Layer 3 Core Switches

1. `ip routing`
2. One SVI per VLAN with its **own** address (Core-1 `.2`, Core-2 `.3`)
3. HSRP on every SVI: same group and **virtual IP**. Core-1 priority 110 with `preempt`, Core-2 left at 100.
4. Uplink to the gateway as a **routed port** (`no switchport`) in its /30
5. RIPv2 with `no auto-summary`, advertising `10.0.0.0`

Configs: [`configs/core-1.txt`](configs/core-1.txt), [`configs/core-2.txt`](configs/core-2.txt)

## 4. Gateway Router

1. Address both /30 links to the cores and the ISP link
2. RIPv2 for the campus, a static default route to the ISP, and `default-information originate`
3. NAT overload: an ACL that matches `10.20.0.0/16`, `ip nat inside` on the core links, `ip nat outside` on the ISP link

Config: [`configs/gateway-router.txt`](configs/gateway-router.txt)

## 5. ISP Router

Only needs its interface address. Because PAT presents the campus as one public IP, the ISP needs no routes back into private space.

Config: [`configs/isp-router.txt`](configs/isp-router.txt)

---

## 6. Verification Checklist

| Test | Command | Expected |
|---|---|---|
| Same VLAN, different building | `ping` from a PC | Replies, so trunks carry the VLAN |
| Different VLAN | `ping` from a PC | Replies, so SVI routing works |
| Gateway interfaces | `ping 10.20.2.97` | Replies |
| ISP | `ping 203.0.113.1` | Replies |
| HSRP state | `show standby brief` | Core-1 Active, Core-2 Standby |
| Routing | `show ip route rip` | All campus subnets + default route |
| NAT | `show ip nat translations` | Inside-local → 203.0.113.2 mappings |
| Failover | Shut Core-1, then ping | A brief drop, then replies via Core-2 |
