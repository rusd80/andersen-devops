#!/bin/env bash

function get_ips(){
  # get connections with netstat
  [ $tool == 'netstat' ] && local res=$(sudo netstat -tunapl | awk -v pat=$1 '$0 ~pat {print $5}' | cut -d: -f1 | sort | uniq -c |
sort | grep -oP '(\d+\.){3}\d+' )
  # get connections with ss
  [ $tool == 'ss' ] && local res=$(ss -tunap | awk -v pat=$1 '$0 ~pat {print $6}' | sort | uniq -c | grep -oP '(\d+\.){3}\d+' )
  echo $res
}

function get_info(){
  [ $mode == 'normal' ] && local res=$(whois $1 | awk -F':' '/^Organization|^role/ {print $2}' | cut -d'(' -f1 )
  [ $mode == 'wide' ] && local res=$(whois $1 | awk -F':' '/^Organization|organization|^OrgName|org-name|ddress|^OrgTechEmail|mailbox/ {print $2}' ORS="  |  "  )
  echo $res
}

function print_frame(){
  separator="+--------------------|--------------------------------------------------+"
  echo $separator
  printf "%-70s | \n" \
                 "| Number of connects |  Organization         [ Info ]        "
  echo $separator
}

# define "help" message
help=$'
usage: ./script.sh [PROCESS NAME or PID] [LINES LIMIT] [MODE]
Shows the names of the organizations with which the PROCESS has
established a connection. The list of organizations is sorted in
descending order of the number of connections

Examples:
$ ./script.sh chrome 9
$ ./script.sh chrome 10 -w
$ ./script.sh -h or --help'

