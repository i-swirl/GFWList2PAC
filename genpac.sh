#/bin/sh

SSHOST="192.168.1.10"
SH_PATH=$(dirname $(readlink -f "$0"))
BASEDIR=$(realpath $0)
cd $(dirname $BASEDIR)

rm -f $SH_PATH/genpac.pac

genpac --format=pac \
	--pac-proxy="SOCKS5 $SSHOST:1988; SOCKS $SSHOST:1988; PROXY $SSHOST:1989; DIRECT" \
	--proxy="SOCKS5://192.168.1.10:1988" \
	--output="$SH_PATH/genpac.pac" \
	--gfwlist-url="https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt" \
	--gfwlist-local="$SH_PATH/gfwlist.txt" \
	--gfwlist-update-local \
    --user-rule="||wikipedia.org" \
	--user-rule="||google.com" \
	--user-rule="@@sina.com" \
	--user-rule="twitter.com" \
	--user-rule-from="$SH_PATH/user.rule" \
	--user-rule-from="$SH_PATH/user-rules.txt" \
	--gfwlist-decoded-save="$SH_PATH/gfwlist-decoded.file" 

:<<eof
genpac --format=pac \
	--pac-proxy="SOCKS5 192.168.1.10:1988" \
	--proxy="http://192.168.1.10:1988"
	--gfwlist-local=./gfwlist.txt \
	--update-gfwlist-local \
	--user-rule-from=./user.rule \
	--gfwlist-decoded-save=./gfwlist-decoded.file \
	--output=./genpac.pac
eof
