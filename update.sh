#!/bin/bash

SSHOST="192.168.1.10"

BASEDIR=$(realpath $0)
cd $(dirname $BASEDIR)

curl --stderr /dev/null --socks5-hostname 192.168.1.10:1988 https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt --output gfwlist.txt
if [ $? -eq 0 ]
then
    #/usr/local/bin/gfwlist2pac -i gfwlist.txt --user-rule user.rule -f ss.pac -p "SOCKS5 $SSHOST:1988; SOCKS $SSHOST:1988; PROXY $SSHOST:1989; DIRECT"
    #/usr/local/bin/gfwlist2pac -i gfwlist.txt --user-rule user.rule -f wpad.dat -p "PROXY $SSHOST:1989; DIRECT"
    ./main.py -i gfwlist.txt --user-rule user.rule -f ss.pac -p "SOCKS5 $SSHOST:1988; SOCKS $SSHOST:1988; PROXY $SSHOST:1989; DIRECT"
    ./main.py -i gfwlist.txt --user-rule user.rule -f wpad.dat -p "PROXY $SSHOST:1989; DIRECT"
    # 让 dnsmasq 把指定域名的 DNS 查询，转发到本机 127.0.0.1:1053这个 DNS 服务上，而不是走系统默认的上游 DNS。
    cat ss.pac | grep '": '| sed -E 's/^.*\"(.*)\":.*$/server=\/\1\/127.0.0.1#1053/' > /etc/dnsmasq.d/gfw.conf
    systemctl restart dnsmasq
fi
