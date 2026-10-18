# Network Technologies Labs

Cisco networking labs built and tested in **Cisco Packet Tracer**, covering campus switching, gateway redundancy, routing, NAT and IPv6 migration.

| # | Lab | Highlights |
|---|-----|-----------|
| 01 | [Multi-Building Campus Network](01-campus-vlan-hsrp-nat/) | VLSM subnetting, VLANs & 802.1Q trunks, Layer 3 switching, HSRP, RIPv2, NAT overload |
| 02 | [IPv6 Migration with NAT-PT](02-ipv6-dual-stack-ospf-nat-pt/) | IPv6 subnet planning, OSPFv2 + OSPFv3, NAT-PT IPv6↔IPv4 translation, traceroute verification |

Each lab folder contains:

| File | Purpose |
|---|---|
| `README.md` | Scenario, design, skills and lessons learned |
| `lab_summary.md` | Walkthrough of my Packet Tracer build with screenshots |
| `screenshots/` | Evidence from my build (identifiers blurred) |
| `runbook.md` | Reusable design and build steps using documentation (example) addresses |
| `configs/` | Reference IOS configs with example addressing |
| `troubleshooting.md` | Pitfalls I ran into, or watched for, and how to fix them |

> The runbooks and configs use RFC 5737 / RFC 3849 documentation addresses (`192.0.2.0/24`, `198.51.100.0/24`, `203.0.113.0/24`, `2001:db8::/32`) and private `10.0.0.0/8` space. They are reference material, not copies of any assessed configuration.
