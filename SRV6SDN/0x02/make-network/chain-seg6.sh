set -xe

ip netns exec R1 ip rule add prio 100 from 10.1.0.11 table 100
ip netns exec R1 ip route add default encap seg6 mode encap segs FF:1::1,FF:2::1,F2::10 dev net2 table 100
ip netns exec R1 ip route list table 100
ip netns exec R1 ip route add ff:1::/64 via 2001:2::2 table 100
ip netns exec R1 ip route add ff:2::/64 via 2001:2::2 table 100
ip netns exec R1 ip route add ff:3::/64 via 2001:2::2 table 100

ip netns exec R2 ip route add ff:1::/64 via 2001:3::1/64 table 100
ip netns exec R2 ip route add ff:2::/64 via 2001:3::1/64 table 100
ip netns exec R2 ip route add ff:3::/64 via 2001:3::1/64 table 100

ip netns exec R1 ip route add ff:1::/64 via 2001:4::2/64 table 100
ip netns exec R2 ip route add ff:2::/64 via 2001:5::1/64 table 100
ip netns exec R3 ip route add ff:3::/64 via 2001:6::1/64 table 100

ip netns exec F1 ip route add ff:1::1/128 encap seg6local action End dev net0
ip netns exec F1 ip addr add ff:1::ffff/128 dev lo
ip netns exec F2 ip route add ff:2::1/128 encap seg6local action End dev net0
ip netns exec F2 ip addr add ff:2::ffff/128 dev lo
ip netns exec F3 ip route add ff:3::1/128 encap seg6local action End dev net0
ip netns exec F3 ip addr add ff:3::ffff/128 dev lo

