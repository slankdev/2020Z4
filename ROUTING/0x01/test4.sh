# !/bin/bash
set -eu
set -x

ip netns exec C1 ping -c1 10.3.0.2
ip netns exec C1 ping -c1 10.2.0.2
ip netns exec C1 ping -c1 10.4.0.2

ip netns exec C2 ping -c1 10.1.0.2
ip netns exec C2 ping -c1 10.3.0.2
ip netns exec C2 ping -c1 10.4.0.2

ip netns exec C3 ping -c1 10.1.0.2
ip netns exec C3 ping -c1 10.2.0.2
ip netns exec C3 ping -c1 10.4.0.2

ip netns exec C4 ping -c1 10.1.0.2
ip netns exec C4 ping -c1 10.2.0.2
ip netns exec C4 ping -c1 10.3.0.2

ip netns exec C1 ping -c1 10.255.2.2
ip netns exec C1 ping -c1 10.255.4.2

ip netns exec C2 ping -c1 10.255.2.2
ip netns exec C2 ping -c1 10.255.4.2

ip netns exec C3 ping -c1 10.255.3.2
ip netns exec C3 ping -c1 10.255.5.2

ip netns exec C4 ping -c1 10.255.3.2
ip netns exec C4 ping -c1 10.255.5.2