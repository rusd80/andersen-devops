#!/bin/env bash

. ./functions.sh
# - help
[[ $1 == '-h' || $1 == '--help' ]] && echo "$help" && exit 0
[ -z "$(which ss)" ] && err "Please install iproute2 package." && exit 2
[ -z "$(which whois)" ] && err "Please install whois package." && exit 2
[ -z "$(which netstat)" ] && err "Please install netstat package." && exit 2

# default values of parameters
number=5 ; mode="normal" ; tool="netstat" ; state="established"

# parse and check parameters
[ $1 == '-n' ] && number=$2 && shift && shift || { echo "Error: bad -n parameter"; exit 3; }
[ $1 == '-s' ] && state=$2 && shift && shift || { echo "Error: bad -s parameter"; exit 3; }
[ $1 == '-w' ] && mode="wide" && shift
[ $1 == '-t' ] && tool="ss" && shift
process="${1}"
[ -z "$process" ] && echo 'Error: process or PID dont set' && exit 3

# get an IP list by process name or PID
ip_list=$(get_ips $process)

# check for empty ip list
[ -z "$ip_list" ] && echo 'No connections found for given PID or process name' && exit 4

# get data from whois
for ip in $ip_list
do
  info=$(get_info $ip)
  [[ -n "$info" && -n "$org_list" ]] && org_list+=$'\n'
  [ -n "$info" ] && org_list+=$'\t\t'$(echo $info)
done

print_frame

# processing and output of result
echo -e "$org_list" |sort | uniq -c | sort -nr | head -n$number
