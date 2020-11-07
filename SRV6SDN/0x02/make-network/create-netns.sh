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