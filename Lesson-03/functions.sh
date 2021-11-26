#!/bin/env bash

function get_ips(){
  local res=$(ss -tunap | awk -v pat=$1 '$0 ~pat {print $6}' | sort | uniq -c | grep -oP '(\d+\.){3}\d+' )
  echo $res
}

function get_info(){
  [ $mode == 'normal' ] && local res=$(whois $1 | awk -F':' '/^Organization|^role/ {print $2}' | cut -d'(' -f1 )
  [ $mode == 'wide' ] && local res=$(whois $1 | awk -F':' '/^Organization|organization|^OrgName|org-name|ddress|^OrgTechEmail|mailbox/ {print $2}' ORS="  |  "  )
  echo $res
}

function print_frame(){
  separator_line="+--------------------|--------------------------------------------------+"
  echo $separator_line
  printf "%-70s | \n" \
                 "| Number of connects |  Organization         [ Info ]        "
  echo $separator_line
}