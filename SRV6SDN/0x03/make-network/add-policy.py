import subprocess


def ensure_rule(rule):
    # TODO: KOKO_NI_NANIKA_WO_KAKU!!
    #c0 = ["ip", "netns", "exec"]
    #src = "10.1.0.11"
    #dst = "10.2.0.14"
    #tab = 100
    #slu = "FF:1::1,FF:2::1"
    #sld = "FF:2::1,FF:1::1"

    subprocess.run(c0 + ["R1", "ip", "rule", "add", "prio", tab, 
                         "from", src, "to", dst, "table", tab])
    subprocess.run(c0 + ["R1", "ip", "route", "add", "{}/32".format(dst), 
                         "encap", "seg6", "mode", "encap", "segs", 
                         "{},F2::10".format(slu), "dev", "net2", "table", tab])

    subprocess.run(c0 + ["R2", "ip", "rule", "add", "prio", tab, 
                         "from", dst, "to", src, "table", tab])
    subprocess.run(c0 + ["R2", "ip", "route", "add", "{}/32".format(src), 
                         "encap", "seg6", "mode", "encap", "segs", 
                         "{},F1::10".format(sld), "dev", "net2", "table", tab])

    
def main():
    #- id: 100
    #  target_src: 10.1.0.11 #C1
    #  target_dst: 10.2.0.14 #C4
    #  functions: [FF:1::1, FF:2::1]
    rule = {}
    rule["id"] = 100
    rule["target_src"] = "10.1.0.11"
    rule["target_dst"] = "10.2.0.14"
    rule["functions"] = ["FF:1::1", "FF:2::1"]
    ensure_rule(rule)
    
    
if __name__ == '__main__':
    main()
