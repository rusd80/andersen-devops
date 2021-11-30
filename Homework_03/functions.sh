#!/bin/env bash

function get_ips(){
  # get connections with netstat
  [ $tool == 'netstat' ] && local res=$(sudo netstat -tunapl | grep $state |awk -v pat=$1 '$0 ~pat {print $5}' | cut -d: -f1 | sort | uniq -c |
sort | grep -oP '(\d+\.){3}\d+' )
  # get connections with ss
  [ $tool == 'ss' ] && local res=$(ss -tunap | grep $state | awk -v pat=$1 '$0 ~pat {print $6}' | sort | uniq -c | grep -oP '(\d+\.){3}\d+' )
  echo $res
}

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


