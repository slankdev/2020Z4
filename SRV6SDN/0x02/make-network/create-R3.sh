set -xe
ip netns add F1
ip netns add F2
ip netns add F3
ip netns add R3

ip -all netns exec ip link set lo up
ip link add net2 netns R1 type veth peer name net4 netns R3
ip link add net2 netns R2 type veth peer name net0 netns R3
ip link add net0 netns F1 type veth peer name net1 netns R3
ip link add net0 netns F2 type veth peer name net2 netns R3
ip link add net0 netns F3 type veth peer name net3 netns R3

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
