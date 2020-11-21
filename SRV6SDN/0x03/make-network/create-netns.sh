set -xe

ip netns add C1
ip netns add C2
ip netns add C3
ip netns add C4
ip netns add C5
ip netns add C6
ip netns add R1
ip netns add R2
ip netns add S1
ip netns add S2
ip netns add F1
ip netns add F2
ip netns add F3
ip netns add R3

ip -all netns exec ip link set lo up
ip link add net0 netns R1 type veth peer name net0 netns R2
ip link add net1 netns R1 type veth peer name net0 netns S1
ip link add net1 netns R2 type veth peer name net0 netns S2
ip link add net0 netns C1 type veth peer name net1 netns S1
ip link add net0 netns C2 type veth peer name net2 netns S1
ip link add net0 netns C3 type veth peer name net3 netns S1
ip link add net0 netns C4 type veth peer name net1 netns S2
ip link add net0 netns C5 type veth peer name net2 netns S2
ip link add net0 netns C6 type veth peer name net3 netns S2
ip link add net2 netns R1 type veth peer name net4 netns R3
ip link add net2 netns R2 type veth peer name net0 netns R3
ip link add net0 netns F1 type veth peer name net1 netns R3
ip link add net0 netns F2 type veth peer name net2 netns R3
ip link add net0 netns F3 type veth peer name net3 netns R3

ip -n R1 link set net0 up
ip -n R1 link set net1 up
ip -n R1 addr add 2001:1::1/64 dev net0
ip -n R1 addr add 10.1.0.1/24  dev net1

ip -n R2 link set net0 up
ip -n R2 link set net1 up
ip -n R2 addr add 2001:1::2/64 dev net0
ip -n R2 addr add 10.2.0.1/24  dev net1

ip -n S1 link add br0 type bridge
ip -n S1 link set br0 up
ip -n S1 link set net0 up
ip -n S1 link set net1 up
ip -n S1 link set net2 up
ip -n S1 link set net3 up
ip -n S1 link set net0 master br0
ip -n S1 link set net1 master br0
ip -n S1 link set net2 master br0
ip -n S1 link set net3 master br0

ip -n S2 link add br0 type bridge
ip -n S2 link set br0 up
ip -n S2 link set net0 up
ip -n S2 link set net1 up
ip -n S2 link set net2 up
ip -n S2 link set net3 up
ip -n S2 link set net0 master br0
ip -n S2 link set net1 master br0
ip -n S2 link set net2 master br0
ip -n S2 link set net3 master br0

ip -all netns exec ip link set net0 up
ip -n C1 addr add 10.1.0.11/24 dev net0; ip -n C1 route add default via 10.1.0.1
ip -n C2 addr add 10.1.0.12/24 dev net0; ip -n C2 route add default via 10.1.0.1
ip -n C3 addr add 10.1.0.13/24 dev net0; ip -n C3 route add default via 10.1.0.1
ip -n C4 addr add 10.2.0.14/24 dev net0; ip -n C4 route add default via 10.2.0.1
ip -n C5 addr add 10.2.0.15/24 dev net0; ip -n C5 route add default via 10.2.0.1
ip -n C6 addr add 10.2.0.16/24 dev net0; ip -n C6 route add default via 10.2.0.1

ip -n R1 link set net2 up
ip -n R1 addr add 2001:2::1/64 dev net2 
ip -n R2 link set net2 up
ip -n R2 addr add 2001:3::1/64 dev net2
ip -n R3 link set net0 up
ip -n R3 link set net1 up
ip -n R3 link set net2 up
ip -n R3 link set net3 up
ip -n R3 link set net4 up
ip -n R3 addr add 2001:3::2/64 dev net0
ip -n R3 addr add 2001:4::2/64 dev net1
ip -n R3 addr add 2001:5::2/64 dev net2
ip -n R3 addr add 2001:6::2/64 dev net3
ip -n R3 addr add 2001:2::2/64 dev net4
ip -n F1 link set net0 up
ip -n F1 addr add 2001:4::1/64 dev net0
ip -n F2 link set net0 up
ip -n F2 addr add 2001:5::1/64 dev net0
ip -n F3 link set net0 up
ip -n F3 addr add 2001:6::1/64 dev net0
ip netns exec R3 sysctl net.ipv6.conf.all.forwarding=1

#End.DT4
ip netns exec R1 ip link add vrf10 type vrf table 10
ip netns exec R1 ip link set vrf10 up
ip netns exec R1 ip link set net1 vrf vrf10
ip netns exec R1 ip link set net1 up
ip netns exec R1 ip route add 10.2.0.0/24 encap seg6 mode encap segs f2::10 dev net0 vrf vrf10
ip netns exec R1 ip route add 169.254.0.10 dev vrf10
ip netns exec R1 ip route add f1::10 encap seg6local action End.DX4 nh4 169.254.0.10 dev vrf10
ip netns exec R1 ip route add f2::/64 via 2001:1::2
sudo ip netns exec R1 sysctl net.ipv4.conf.all.forwarding=1
sudo ip netns exec R1 sysctl net.ipv6.conf.all.forwarding=1
sudo ip netns exec R1 sysctl net.ipv6.conf.all.seg6_enabled=1
 
ip netns exec R2 ip link add vrf10 type vrf table 10
ip netns exec R2 ip link set vrf10 up
ip netns exec R2 ip link set net1 vrf vrf10
ip netns exec R2 ip link set net1 up
ip netns exec R2 ip route add 10.1.0.0/24 encap seg6 mode encap segs f1::10 dev net0 vrf vrf10
ip netns exec R2 ip route add 169.254.0.10 dev vrf10
ip netns exec R2 ip route add f2::10 encap seg6local action End.DX4 nh4 169.254.0.10 dev vrf10
ip netns exec R2 ip route add f1::/64 via 2001:1::1
sudo ip netns exec R2 sysctl net.ipv4.conf.all.forwarding=1
sudo ip netns exec R2 sysctl net.ipv6.conf.all.forwarding=1
sudo ip netns exec R2 sysctl net.ipv6.conf.all.seg6_enabled=1

#chain
ip netns exec R1 ip rule add prio 100 from 10.1.0.11 table 100
ip netns exec R1 ip route add 10.2.0.0/24 encap seg6 mode encap segs FF:1::1,FF:2::1,F2::10 dev net2 table 100
ip netns exec R1 ip rule add prio 100 from 10.1.0.12 table 200
ip netns exec R1 ip route add 10.2.0.0/24 encap seg6 mode encap segs FF:2::1,FF:3::1,F2::10 dev net2 table 200
ip netns exec R1 ip rule add prio 100 from 10.1.0.13 table 300
ip netns exec R1 ip route add 10.2.0.0/24 encap seg6 mode encap segs FF:3::1,FF:1::1,F2::10 dev net2 table 300

ip netns exec R2 ip rule add prio 100 to 10.1.0.11 table 400
ip netns exec R2 ip route add 10.1.0.0/24 encap seg6 mode encap segs FF:2::1,FF:1::1,F1::10 dev net2 table 400
ip netns exec R2 ip rule add prio 100 to 10.1.0.12 table 500
ip netns exec R2 ip route add 10.1.0.0/24 encap seg6 mode encap segs FF:3::1,FF:2::1,F1::10 dev net2 table 500
ip netns exec R2 ip rule add prio 100 to 10.1.0.13 table 600
ip netns exec R2 ip route add 10.1.0.0/24 encap seg6 mode encap segs FF:1::1,FF:3::1,F1::10 dev net2 table 600

#ip netns exec R1 ip route list table 100
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
