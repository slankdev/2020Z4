set -xe
ip netns exec R1 ip rule add prio 100 from 10.1.0.11 table 100
ip netns exec R1 ip route add default encap seg6 mode encap segs 2001:2::2,2001:4::1,2001:5::1,2001:3::2 dev net2 table 100
##EXAMPLE: ip netns exec R1 ip route add default encap seg6 mode encap segs FF:1::1,FF:2::1,F2::10 dev net2 table 100
#ip netns exec R1 ip route add default encap seg6 mode encap segs 2::,4::,5::,3:: dev net0 table 100
ip netns exec R1 ip route list table 100

