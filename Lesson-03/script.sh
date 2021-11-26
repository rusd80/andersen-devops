#!/bin/env bash

. ./functions.sh
# define "help" message
help=$'
usage: ./whoscript.sh [PROCESS NAME or PID] [LINES LIMIT]
Shows the names of the organizations with which the PROCESS has
established a connection.
Examples:
$ ./whoscript.sh chrome 3
$ ./whoscript.sh -h or --help'

# argument - help
[[ $1 == '-h' || $1 == '--help' ]] && echo "$help" && exit 0

[ -z "$1" ] && echo "Error: process name or PID required" && exit 1
[ -z "$2" ] && echo "Error: number of outputs required" && exit 1

[ -z "$(which ss)" ] && err "Please install iproute2 package." && exit 2
[ -z "$(which whois)" ] && err "Please install whois package." && exit 2

[ "$3" == '-w' ] && mode='wide' || mode='normal'

ip_list=$(get_ips $1 $2)

[ -z "$ip_list" ] && echo 'No connections found for given PID or process name' && exit 3

for ip in $ip_list
do
  [ $mode == 'normal' ] && echo $(get_info $ip)
  [ $mode == 'wide' ] && echo $(get_info_wide $ip)
done








