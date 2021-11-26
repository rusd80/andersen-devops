#!/bin/env bash

. ./functions.sh
# - help
[[ $1 == '-h' || $1 == '--help' ]] && echo "$help" && exit 0
[ -z "$(which ss)" ] && err "Please install iproute2 package." && exit 2
[ -z "$(which whois)" ] && err "Please install whois package." && exit 2

[ -z "$1" ] && echo "Error: process name or PID required" && exit 1
[ -z "$2" ] && echo "Error: number of outputs required" && exit 1
[ -z "$3" ] && echo "Error: mode required" && exit 1

[ "$3" == '-w' ] && mode='wide'
[ "$3" == '-n' ] && mode='normal'

ip_list=$(get_ips $1 $2)

[ -z "$ip_list" ] && echo 'No connections found for given PID or process name' && exit 3

for ip in $ip_list
do
  info=$(get_info $ip)
  [[ -n "$info" && -n "$org_list" ]] && org_list+=$'\n'
  [ -n "$info" ] && org_list+=$'\t\t'$(echo $info)
done

print_frame

echo -e "$org_list" |sort | uniq -c | sort -nr | head -n$2
