# 01 – Multi-Building Campus Network

**Cisco Packet Tracer · VLANs · HSRP · RIPv2 · NAT**

## Scenario

A campus has five departments spread over several buildings, with PCs and IP phones in each one and a server room holding one server per department. The network must:

- Keep departments in **separate VLANs and subnets**, even when they share a building
- Use the address space efficiently, sizing **each subnet to its host count**
- Keep working if **one core switch fails**
- Give every department internet access through a **single public address**

## Design

```text
                 ISP router
                     │  public /30
              Gateway router  (NAT overload, default route)
               ╱            ╲   routed /30 links, RIPv2
     L3 Core-1 (HSRP active) ══ L3 Core-2 (HSRP standby)
        │  ╲   ╲   ╲  802.1Q trunks to every access switch  ╱
   Bldg-1   Bldg-2   Bldg-3   Bldg-4        Server building
   2960     2960     2960     2960          2960 + dept servers
   VLANs per department: PCs + IP phones
```

## What I Practised

- **VLSM:** sizing subnets from largest to smallest host requirement
- Creating VLANs, **access ports** and **802.1Q trunks** on 2960 access switches
- **Inter-VLAN routing** with SVIs on Layer 3 switches (`ip routing`)
- **HSRP** per VLAN, with priorities and preemption, for a redundant default gateway
- **RIPv2** between the core switches and the gateway router
- **NAT overload (PAT)** at the edge to the ISP
- Testing intra-VLAN, inter-VLAN, edge and internet reachability, then **failing a core switch** to prove HSRP works

## Why It Matters

| Real-world need | Technique |
|---|---|
| Separate departments for security and broadcast control | VLANs + one subnet per VLAN |
| Don't waste address space | VLSM |
| No single point of failure at the gateway | HSRP on two L3 switches |
| Many users, one public IP | NAT overload / PAT |

## Files

| File | Description |
|---|---|
| [`lab_summary.md`](lab_summary.md) | Walkthrough of my build with screenshots |
| [`screenshots/`](screenshots/) | Topology and verification evidence |
| [`runbook.md`](runbook.md) | VLSM plan and build steps (example addressing) |
| [`configs/`](configs/) | Reference configs for the access switch, core switches, gateway and ISP |
| [`troubleshooting.md`](troubleshooting.md) | Common pitfalls and fixes |

## What I Learned

- The HSRP **virtual IP must be different** from each switch's own SVI address. Hosts point at the virtual IP.
- Turn off RIPv2 `auto-summary`, otherwise subnets of the same major network get summarised and routes break.
- In NAT, the `inside` and `outside` interface roles matter as much as the ACL that matches the traffic.
- The first ping after a change often loses one packet while ARP resolves. That's normal, not a fault.
