# Troubleshooting – Campus Network

| Symptom | Likely cause | Fix |
|---|---|---|
| HSRP shows *Init* / duplicate address warnings | SVI address is the same as the HSRP virtual IP | Give each SVI its own address and keep the virtual IP separate |
| Both cores think they're Active | Different HSRP group numbers or virtual IPs on the two cores | Match the `standby <group> ip` on both switches |
| Core-1 doesn't take back over after recovering | `preempt` missing | Add `standby <group> preempt` on the higher-priority switch |
| PCs in the same VLAN but different buildings can't ping | Uplink not trunking, or VLAN missing on a switch | `show interfaces trunk`, then create the VLAN on every switch |
| Inter-VLAN ping fails but same-VLAN works | `ip routing` not enabled on the L3 switch, or SVI is shut down | `ip routing`, then `no shutdown` on the SVI |
| Some subnets missing from routing tables | RIPv2 auto-summarising | `no auto-summary` under `router rip` |
| Internet ping fails but the gateway is reachable | NAT inside/outside roles reversed, or ACL doesn't match the subnets | Check `ip nat inside/outside` per interface and the ACL wildcard |
| Broadcast/host range doesn't match the plan | Arithmetic error when subnetting | Re-check the block size (256 − mask octet) and the broadcast = next network − 1 |
| First ping shows one timeout | ARP resolution | Normal. Ping again |
