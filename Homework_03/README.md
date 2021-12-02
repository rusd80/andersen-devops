### Lesson 3 homework

## What this one-liner does:
```
sudo netstat -tunapl | awk '/firefox/ {print $5}' | cut -d: -f1 | sort | uniq -c | sort | tail -n5 | grep -oP '(\d+\.){3}\d+' | while read IP ; do whois $IP | awk -F':' '/^Organization/ {print $2}' ; done
```

This script displays the name of the organizations that own the IP addresses to which the process, 
passed as a parameter to this script, connects. The process can be specified by name or by process ID.
- `netstat` - is a command-line utility lets you discover which sockets are connected and which sockets are listening.
- `-t` or --tcp - shows tcp ports
- `-u` or --udp - shows udp ports
- `-n` shows network addresses as numbers, shows ports as numbers
- `-a` shows the status of all sockets; normally, sockets used by server processes are not shown
- `-p` displays the PID/Name of the process that created the socket
- `-l` or --listening - shows only the listening ports
- `awk '/firefox/ {print $5}'`  - looks for lines containing `firefox` and outputs only the fifth column (ip+port), returns list of sockets
- `cut -d: -f1` - cuts the ports, leaving only IP
- `sort` - sorts by the first character in the string
- `uniq -c` looking for repeats of IP addresses and output the number of these repeats
- `sort` - sorts by the first character in the string
- `tail -n5` - shows last five IP addresses
- `grep -oP '(\d+\.){3}\d+'` outputs only IP (one or more decimal numbers with a dot three times and the last octet of IP)

- The result is sending to the `while loop` in which we run all the IP addresses through the `whois` command. 
Command `awk` searches for lines with `Organization` 

- `ss` - is a tool that is used for displaying network socket related information on a Linux system. The tool displays
more detailed information that the netstat command which is used for displaying active socket connections.

### Manual
Download script and run it. You should specify process name or PID as the script argument. Run this script as root to see more details.

usage:
./script.sh [options] <process>

Options:
-n  <number>          number of lines to output, default value: 5
-a                    all connections, default - only `ESTABLISHED`
-w                    more information, default - only `ORGANIZATION` name
-t                    `ss`, default - `netstat`
<process>             `PROCESS NAME OR PID` - name or PID of process to analyze its connections


## Usage example:

```
script.sh -n 10 -a -w -t chrome
script.sh -n 7 zoom
```
## Result of `script.sh -n 10 -a -w -t chrome`:
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

