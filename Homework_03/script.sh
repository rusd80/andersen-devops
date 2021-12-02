#!/bin/env bash

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

# function returns IP`s, uses netstat or ss utility
function get_ips(){
  # get connections with netstat
  [ $tool == 'netstat' ] && local res=$(sudo netstat -tunapl | grep $state |awk -v pat=$1 '$0 ~pat {print $5}' | cut -d: -f1 | sort | uniq -c |
sort | grep -oP '(\d+\.){3}\d+' )
  # get connections with ss
  [ $tool == 'ss' ] && local res=$(ss -tunap | grep $state | awk -v pat=$1 '$0 ~pat {print $6}' | sort | uniq -c | grep -oP '(\d+\.){3}\d+' )
  echo $res
}

# function gets information in 'normal' or 'wide' mode
function get_info(){
  # normal mode - organization only
  [ $mode == 'normal' ] && local res=$(whois $1 | awk -F':' '/^Organization|^role/ {print $2}' | cut -d'(' -f1 )
  # wide mode - more info
  [ $mode == 'wide' ] && local res=$(whois $1 | awk -F':' '/^Organization|organization|^OrgName|org-name|ddress|^OrgTechEmail|mailbox/ {print $2}' ORS="  |  "  )
  echo $res
}

# frame print
function print_frame(){
  separator="+--------------------|--------------------------------------------------+"
  echo $separator
  printf "%-70s | \n" \
                 "| Number of connects |  Organization         [ Info ]        "
  echo $separator
}
# return HELP message
[[ $1 == '-h' || $1 == '--help' ]] && echo "$help" && exit 0

# check utilities installed
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
