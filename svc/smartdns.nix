{...}: {
  services.resolved.enable = false;
  networking.networkmanager.dns = "none";
  networking.nameservers = ["127.0.0.1"];
  services.smartdns = {
    enable = true;
    #bindPort = 53;
    settings = {
      bind = ["127.0.0.1:53"];
      log-level = "debug";
      log-file = "/dev/stdout";
      cache-size = 4096;
      cache-persist = "yes";
      cache-file = "/var/lib/smartdns/smartdns.cache";
      speed-check-mode = "tcp:443";

      server = [
        "211.137.160.5 -group local_isp -exclude-default-group"
      ];

      server-https = [
        "https://dns.alidns.com/dns-query -group china_doh -exclude-default-group"
        "https://doh.pub/dns-query -group china_doh -exclude-default-group"
        "https://1.1.1.1/dns-query -group foreign_doh -exclude-default-group"
        "https://8.8.8.8/dns-query -group foreign_doh -exclude-default-group"
      ];

      domain-rules = [
        "/msftconnecttest.com/ -nameserver-group local_isp -speed-check-mode none"
        "/ipv6.microsoft.com/ -nameserver-group local_isp -speed-check-mode none"
        "/connectivitycheck.gstatic.com/ -nameserver-group local_isp -speed-check-mode none"
        "/captive.apple.com/ -nameserver-group local_isp -speed-check-mode none"
        "/nmcheck.gnome.org/ -nameserver-group local_isp -speed-check-mode none"
        "/detectportal.firefox.com/ -nameserver-group local_isp -speed-check-mode none"
      ];

      nameserver = [
        "/./foreign_doh"
        "/.cn/china_doh"
        "/.baidu.com/china_doh"
        "/.qq.com/china_doh"
        "/.taobao.com/china_doh"
        "/.aliyun.com/china_doh"
        "/.bilibili.com/china_doh"
        "/.163.com/china_doh"
        "/.jd.com/china_doh"
        "/.zhihu.com/china_doh"
        "/.douyin.com/china_doh"
        "/.weibo.com/china_doh"
      ];
    };
  };
}
