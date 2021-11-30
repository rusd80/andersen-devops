### Lesson 3 homework

## What this one-liner does
This script displays the name of the organizations that own the IP addresses to which the process, passed as a parameter to this script, connects. The process can be specified by name or by proccess ID.
```
netstat - is a command-line utility for working with the network, for displaying various network parameters depending on the specified options.
-t or --tcp - show tcp ports
-u or --udp - show udp ports
-n Show network addresses as numbers. Show ports as number, not letters. (443 - https, etc.)
-a Shows the status of all sockets; normally, sockets used by server processes are not shown.
-p Display the PID/Name of the process that created the socket.
-l or --listening - view only the listening ports.
awk '/firefox/ {print $5}'in the output of the netstat command, we look for lines containing firefox and output the fifth column (ip+port)
cut -d: -f1 we cut the ports, leaving only IP
sort sort (by the first character in the string)
uniq -c looking for repeats of IP addresses and output the number of these repeats
sort sort again
tail -n5 show last five IP addresses
grep -oP '(\d+\.){3}\d+' output only IP (one or more decimal numbers with a dot three times and the last octet of IP)
We send the result to the while loop in which we run all the IP addresses through the whois command. Using awk, we search for lines with Organization: and deduce the fact that after the : (name of the organization)
```

### Manual
Download script and run it. You should specify process name or PID as the script argument. Run this script as root to see more details.

usage:
./script.sh [options] <process>

Options:
-n  <number>          number of lines to output,default value: 5
-a                    all connections, default - only ESTABLISHED
-w                    more information, default - only ORGANIZATION name
-t                    `ss`, default - `netstat`
<process>             PROCESS NAME OR PID - name or PID of process to analyze its connections


## Usage example:

```
script.sh -n 10 -a -w -t chrome
script.sh -n 7 zoom
```
## result:
```
| Number of connects |  Organization         [ Info ]                  | 
+--------------------|--------------------------------------------------+
      6                 Google LLC (GOGL) | Google LLC | 1600 Amphitheatre Parkway | US | arin-contact@google.com |
      2                 Facebook Ireland Ltd | 4 GRAND CANAL SQUARE , GRAND CANAL HARBOUR , | D2 | Dublin | IRELAND | 1601 Willow Rd. | Menlo Park, CA, 94025 | domain@fb.com |
      1                 Stack Exchange, Inc. (SE-111) | Stack Exchange, Inc. | 110 William St. | Floor 28 | US | sysadmin-team@stackexchange.com |
      1                 iHome Ltd. | 1A Semenovskaya pl. | 107023, Moscow, Russia | abuse@ihome.ru |
      1                 GitHub, Inc. (GITHU) | GitHub, Inc. | 88 Colin P Kelly Jr Street | US | hostmaster@github.com |
      1                 Facebook, Inc. (THEFA-3) | Facebook, Inc. | 1601 Willow Rd. | US | domain@facebook.com |

```