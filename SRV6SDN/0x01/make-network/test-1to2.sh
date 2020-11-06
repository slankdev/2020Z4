set -ex

ip netns exec C1 ping -c1 10.1.0.12
ip netns exec C1 ping -c1 10.1.0.13
ip netns exec C1 ping -c1 10.2.0.14
ip netns exec C1 ping -c1 10.2.0.15
ip netns exec C1 ping -c1 10.2.0.16

ip netns exec C2 ping -c1 10.1.0.11
ip netns exec C2 ping -c1 10.1.0.13
ip netns exec C2 ping -c1 10.2.0.14
ip netns exec C2 ping -c1 10.2.0.15
ip netns exec C2 ping -c1 10.2.0.16

ip netns exec C3 ping -c1 10.1.0.11
ip netns exec C3 ping -c1 10.1.0.12
ip netns exec C3 ping -c1 10.2.0.14
ip netns exec C3 ping -c1 10.2.0.15
ip netns exec C3 ping -c1 10.2.0.16

ip netns exec C4 ping -c1 10.1.0.11
ip netns exec C4 ping -c1 10.1.0.12
ip netns exec C4 ping -c1 10.1.0.13
ip netns exec C4 ping -c1 10.2.0.15
ip netns exec C4 ping -c1 10.2.0.16

ip netns exec C5 ping -c1 10.1.0.11
ip netns exec C5 ping -c1 10.1.0.12
ip netns exec C5 ping -c1 10.1.0.13
ip netns exec C5 ping -c1 10.2.0.14
ip netns exec C5 ping -c1 10.2.0.16

ip netns exec C6 ping -c1 10.1.0.11
ip netns exec C6 ping -c1 10.1.0.12
ip netns exec C6 ping -c1 10.1.0.13
ip netns exec C6 ping -c1 10.2.0.14
ip netns exec C6 ping -c1 10.2.0.15

