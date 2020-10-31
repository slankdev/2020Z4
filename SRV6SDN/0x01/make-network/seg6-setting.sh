set -x

#R1-settings
ip netns exec R1 ip link add vrf10 type vrf table 10
ip netns exec R1 ip link set vrf10 up
ip netns exec R1 ip link set net1 vrf vrf10
ip netns exec R1 ip link set net1 up

ip netns exec R1 ip route add 10.2.0.0/24 encap seg6 mode encap segs f2::10 dev net0 vrf vrf10

ip netns exec R1 ip route add 169.254.0.10 dev vrf10
ip netns exec R1 ip route add f1::10 encap seg6local action End.DX4 nh4 169.254.0.10 dev vrf10

sudo ip netns exec R1 sysctl net.ipv4.conf.all.forwarding=1
sudo ip netns exec R1 sysctl net.ipv6.conf.all.forwarding=1
sudo ip netns exec R1 sysctl net.ipv6.conf.all.seg6_enabled=1
sudo ip netns exec R1 sysctl net.ipv4.conf.all.rp_filter=0


#R2-settings
ip netns exec R2 ip link add vrf10 type vrf table 10
ip netns exec R2 ip link set vrf10 up
ip netns exec R2 ip link set net1 vrf vrf10
ip netns exec R2 ip link set net1 up

ip netns exec R2 ip route add 10.1.0.0/24 encap seg6 mode encap segs f2::10 dev net0 vrf vrf10

ip netns exec R2 ip route add 169.254.0.10 dev vrf10
ip netns exec R2 ip route add f2::10 encap seg6local action End.DX4 nh4 169.254.0.10 dev vrf10

sudo ip netns exec R2 sysctl net.ipv4.conf.all.forwarding=1
sudo ip netns exec R2 sysctl net.ipv6.conf.all.forwarding=1
sudo ip netns exec R2 sysctl net.ipv6.conf.all.seg6_enabled=1
sudo ip netns exec R2 sysctl net.ipv4.conf.all.rp_filter=0