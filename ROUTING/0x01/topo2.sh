# !/bin/bash
set -eu
set -x

# Network Namespaceの作成
sudo ip netns add C1
sudo ip netns add C2
sudo ip netns add R1
sudo ip netns add R2
sudo ip netns add C3
sudo ip netns add C4

# インターフェースの作成
sudo ip link add name C1_net0 type veth peer  name R1_net1
sudo ip link add name C2_net0 type veth peer name R1_net2
sudo ip link add name R1_net0 type veth peer name R2_net0
sudo ip link add name C3_net0 type veth peer  name R2_net1
sudo ip link add name C4_net0 type veth peer  name R2_net2

# インターフェースを各Namespaceに所属させる
sudo ip link set C1_net0 netns C1
sudo ip link set C2_net0 netns C2
sudo ip link set R1_net1 netns R1
sudo ip link set R1_net2 netns R1
sudo ip link set R1_net0 netns R1
sudo ip link set R2_net0 netns R2
sudo ip link set R2_net1 netns R2
sudo ip link set R2_net2 netns R2
sudo ip link set C3_net0 netns C3
sudo ip link set C4_net0 netns C4

# インターフェースへIPアドレスを付与
sudo ip netns exec C1 ip addr add 10.1.0.2/24 dev C1_net0
sudo ip netns exec C2 ip addr add 10.2.0.2/24 dev C2_net0

sudo ip netns exec R1 ip addr add 10.1.0.1/24 dev R1_net1
sudo ip netns exec R1 ip addr add 10.2.0.1/24 dev R1_net2
sudo ip netns exec R1 ip addr add 10.255.1.1/24 dev R1_net0

sudo ip netns exec R2 ip addr add 10.255.1.2/24 dev R2_net0
sudo ip netns exec R2 ip addr add 10.3.0.1/24 dev R2_net1
sudo ip netns exec R2 ip addr add 10.4.0.1/24 dev R2_net2

sudo ip netns exec C3 ip addr add 10.3.0.2/24 dev C3_net0
sudo ip netns exec C4 ip addr add 10.4.0.2/24 dev C4_net0

# インターフェースの起動

sudo ip netns exec C1 ip link set C1_net0 up
sudo ip netns exec C2 ip link set C2_net0 up

sudo ip netns exec R1 ip link set R1_net1 up
sudo ip netns exec R1 ip link set R1_net2 up
sudo ip netns exec R1 ip link set R1_net0 up

sudo ip netns exec R2 ip link set R2_net0 up
sudo ip netns exec R2 ip link set R2_net1 up
sudo ip netns exec R2 ip link set R2_net2 up

sudo ip netns exec C3 ip link set C3_net0 up
sudo ip netns exec C4 ip link set C4_net0 up

sudo ip netns exec C1 ip link set lo up
sudo ip netns exec C2 ip link set lo up
sudo ip netns exec R1 ip link set lo up
sudo ip netns exec R2 ip link set lo up
sudo ip netns exec C3 ip link set lo up
sudo ip netns exec C4 ip link set lo up

# ルーティング有効化
sudo ip netns exec C1 ip route add 0.0.0.0/0 via 10.1.0.1
sudo ip netns exec C2 ip route add 0.0.0.0/0 via 10.2.0.1

sudo ip netns exec R1 ip route add 10.3.0.0/24 via 10.255.1.2
sudo ip netns exec R1 ip route add 10.4.0.0/24 via 10.255.1.2 

sudo ip netns exec C3 ip route add 0.0.0.0/0 via 10.3.0.1
sudo ip netns exec C4 ip route add 0.0.0.0/0 via 10.4.0.1

sudo ip netns exec R2 ip route add 10.1.0.0/24 via 10.255.1.1
sudo ip netns exec R2 ip route add 10.2.0.0/24 via 10.255.1.1

sudo ip netns exec R1 sysctl -w net.ipv4.ip_forward=1
sudo ip netns exec R2 sysctl -w net.ipv4.ip_forward=1
