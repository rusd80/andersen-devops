#!/bin/env bash

. ./functions.sh

# define "help" message
help=$'
usage:
./script.sh [options] <process>

Options:
-n  <number>          number of lines to output,default value: 5
-a                    all connections, default - only ESTABLISHED
-w                    more information, default - only ORGANIZATION name
-t                    `ss`, default - `netstat`
<process>             PROCESS NAME OR PID - name or PID of process to analyze its connections

Shows the names of the organizations with which the PROCESS has
established a connection. The list of organizations is sorted in
descending order of the number of connections

Examples:
$ ./script.sh -n 6 chrome
$ ./script.sh -n 8 -a -w -t zoom
$ ./script.sh -h or --help'

[[ $1 == '-h' || $1 == '--help' ]] && echo "$help" && exit 0
[ -z "$(which ss)" ] && err "Please install iproute2 package." && exit 2
[ -z "$(which whois)" ] && err "Please install whois package." && exit 2
[ -z "$(which netstat)" ] && err "Please install netstat package." && exit 2

# default values of parameters
number=5 ; mode="normal" ; tool="netstat" ; state=ESTAB

# parse and check parameters
while [ -n "$1" ]
do
case "$1" in
-n) number="$2"
shift ;;
-a) state=".";;
-w) mode="wide";;
-t) tool="ss";;
*) break;;
esac
shift
done

process=$1

# check process name or PID
[ -z "$process" ] && echo 'Error: process or PID don`t set' && exit 3

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
