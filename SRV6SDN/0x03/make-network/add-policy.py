import subprocess


subprocess.run(["ip", "netns", "exec", "R1", "ip", "rule", "add", "prio", "100", "from", "10.1.0.11", "table", "100"])
subprocess.run(["ip", "netns", "exec", "R1", "ip", "route", "add", "10.2.0.0/24", "encap", "seg6", "mode", "encap", "segs", "FF:1::1,FF:2::1,F2::10", "dev", "net2", "table", "100"])
subprocess.run(["ip", "netns", "exec", "R1", "ip", "rule", "add", "prio", "100", "from", "10.1.0.12", "table", "200"])
subprocess.run(["ip", "netns", "exec", "R1", "ip", "route", "add", "10.2.0.0/24", "encap", "seg6", "mode", "encap", "segs", "FF:2::1,FF:3::1,F2::10", "dev", "net2", "table", "200"])
subprocess.run(["ip", "netns", "exec", "R1", "ip", "rule", "add", "prio", "100", "from", "10.1.0.13", "table", "300"])
subprocess.run(["ip", "netns", "exec", "R1", "ip", "route", "add", "10.2.0.0/24", "encap", "seg6", "mode", "encap", "segs", "FF:3::1,FF:1::1,F2::10", "dev", "net2", "table", "300"])
subprocess.run(["ip", "netns", "exec", "R2", "ip", "rule", "add", "prio", "100", "to", "10.1.0.11", "table", "400"])
subprocess.run(["ip", "netns", "exec", "R2", "ip", "route", "add", "10.1.0.0/24", "encap", "seg6", "mode", "encap", "segs", "FF:2::1,FF:1::1,F1::10", "dev", "net2", "table", "400"])
subprocess.run(["ip", "netns", "exec", "R2", "ip", "rule", "add", "prio", "100", "to", "10.1.0.12", "table", "500"])
subprocess.run(["ip", "netns", "exec", "R2", "ip", "route", "add", "10.1.0.0/24", "encap", "seg6", "mode", "encap", "segs", "FF:3::1,FF:2::1,F1::10", "dev", "net2", "table", "500"])
subprocess.run(["ip", "netns", "exec", "R2", "ip", "rule", "add", "prio", "100", "to", "10.1.0.13", "table", "600"])
subprocess.run(["ip", "netns", "exec", "R2", "ip", "route", "add", "10.1.0.0/24", "encap", "seg6", "mode", "encap", "segs", "FF:1::1,FF:3::1,F1::10", "dev", "net2", "table", "600"])

