# Troubleshooting – IPv6, OSPFv3 & NAT-PT

| Symptom | Likely cause | Fix |
|---|---|---|
| Router won't forward IPv6 between interfaces | `ipv6 unicast-routing` missing | Enable it globally |
| `ipv6 router ospf` refuses to start | No router ID (no IPv4 address on the router) | `router-id x.x.x.x` under the process |
| OSPFv3 neighbour never appears | Interface not added with `ipv6 ospf <pid> area <a>` | Enable OSPFv3 on **each** interface |
| Adjacency stuck / no route over one link | Prefix typo or different prefix lengths at each end | Compare `show ipv6 interface brief` on both routers |
| OSPFv2 neighbour down to the IPv4 branch | Wildcard mask wrong in `network` | /30 → `0.0.0.3`, /25 → `0.0.0.127` |
| Serial link down/down | No clock rate on the DCE end | `clock rate 64000` on the DCE side |
| IPv6 host can't reach the IPv4 server | Missing v4v6 mapping or `ipv6 nat prefix` | Add both, and put `ipv6 nat` on both the inside and outside interfaces |
| IPv4 host can't reach the IPv6 server | Missing v6v4 mapping | `ipv6 nat v6v4 source <v6> <v4>` |
| `show ipv6 nat translations` empty | No traffic yet, or `ipv6 nat` missing on an interface | Generate a ping, then check the interface config |
