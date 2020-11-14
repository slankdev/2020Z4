set -xe

ip netns exec R1 ip rule add prio 100 from 10.1.0.11 table 100
ip netns exec R1 ip rule add prio 100 from 10.1.0.12 table 200
ip netns exec R1 ip rule add prio 100 from 10.1.0.13 table 300
ip netns exec R1 ip route add 10.2.0.0/24 encap seg6 mode encap segs FF:1::1,FF:2::1,F2::10 dev net2 table 100
ip netns exec R1 ip route add 10.2.0.0/24 encap seg6 mode encap segs FF:2::1,FF:3::1,F2::10 dev net2 table 200
ip netns exec R1 ip route add 10.2.0.0/24 encap seg6 mode encap segs FF:3::1,FF:1::1,F2::10 dev net2 table 300
ip netns exec R1 ip route list table 100
ip netns exec R1 ip route add ff:1::/64 via 2001:2::2 
ip netns exec R1 ip route add ff:2::/64 via 2001:2::2 
ip netns exec R1 ip route add ff:3::/64 via 2001:2::2 
ip netns exec R1 sysctl net.ipv4.conf.net0.rp_filter=0
ip netns exec R1 sysctl net.ipv4.conf.net1.rp_filter=0
ip netns exec R1 sysctl net.ipv4.conf.net2.rp_filter=0
ip netns exec R1 sysctl net.ipv4.conf.all.rp_filter=0

ip netns exec R2 ip route add ff:1::/64 via 2001:3::2 
ip netns exec R2 ip route add ff:2::/64 via 2001:3::2
ip netns exec R2 ip route add ff:3::/64 via 2001:3::2
ip netns exec R2 sysctl net.ipv4.conf.net0.rp_filter=0
ip netns exec R2 sysctl net.ipv4.conf.net1.rp_filter=0
ip netns exec R2 sysctl net.ipv4.conf.net2.rp_filter=0
ip netns exec R2 sysctl net.ipv4.conf.all.rp_filter=0

ip netns exec R3 ip route add ff:1::/64 via 2001:4::1
ip netns exec R3 ip route add ff:2::/64 via 2001:5::1
ip netns exec R3 ip route add ff:3::/64 via 2001:6::1 
ip netns exec R3 ip route add f2::/64 via 2001:3::1
ip netns exec R3 ip route add f1::/64 via 2001:2::1

ip netns exec F1 ip route add ff:1::1/128 encap seg6local action End dev net0
ip netns exec F1 ip addr add ff:1::ffff/128 dev lo
ip netns exec F1 sysctl net.ipv6.conf.all.forwarding=1
ip netns exec F1 sysctl net.ipv6.conf.all.seg6_enabled=1
ip netns exec F1 ip route add default via 2001:4::2
ip netns exec F2 ip route add ff:2::1/128 encap seg6local action End dev net0
ip netns exec F2 ip addr add ff:2::ffff/128 dev lo
ip netns exec F2 sysctl net.ipv6.conf.all.forwarding=1
ip netns exec F2 sysctl net.ipv6.conf.all.seg6_enabled=1
ip netns exec F2 ip route add default via 2001:5::2
ip netns exec F3 ip route add ff:3::1/128 encap seg6local action End dev net0
ip netns exec F3 ip addr add ff:3::ffff/128 dev lo
ip netns exec F3 sysctl net.ipv6.conf.all.forwarding=1
ip netns exec F3 sysctl net.ipv6.conf.all.seg6_enabled=1
ip netns exec F3 ip route add default via 2001:6::2
