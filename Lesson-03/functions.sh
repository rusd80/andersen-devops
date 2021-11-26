#!/bin/env bash

function get_ips(){
  local res=$(ss -tunap | awk -v pat=$1 '$0 ~pat {print $6}' | uniq -c | grep -oP '(\d+\.){3}\d+' | sort | tail -n$2 | uniq -c)
  echo $res
}

function get_info(){
  local res=$(whois $1 | awk -F':' '/^Organization|^role/ {print $2}' )
  echo $res
}

function get_info_wide(){
  local res=$(whois $1 | awk -F':' '/rganization|role|ountry|ddress|^OrgTechEmail|mailbox/ {print $2}' ORS=", "  )
  echo $res
}

