### Lesson 3 homework

## What this one-liner does:
```
sudo netstat -tunapl | awk '/firefox/ {print $5}' | cut -d: -f1 | sort | uniq -c | sort | tail -n5 | grep -oP '(\d+\.){3}\d+' | while read IP ; do whois $IP | awk -F':' '/^Organization/ {print $2}' ; done
```

This script displays names of the organizations that own the IP addresses to which the process, 
passed as a parameter to this script, connects. The process can be specified by name or by process ID.
- `netstat` - is a command-line utility allows you to discover which sockets are connected and which sockets are listening.
- `-t` or --tcp - shows tcp ports
- `-u` or --udp - shows udp ports
- `-n` shows network addresses as numbers, shows ports as numbers
- `-a` shows the status of all sockets; normally, sockets used by server processes are not shown
- `-p` displays the PID/Name of the process that created the socket
- `-l` or --listening - shows only the listening ports
- `awk '/firefox/ {print $5}'`  - looks for lines containing `firefox` and outputs only the fifth column (ip+port), returns list of sockets
- `cut -d: -f1` - cuts the ports, leaving only IP
- `sort` - sorts by the first character in the string
- `uniq -c` looks for repeats of IP addresses and output the number of these repeats
- `sort` - sorts by the first character in the string
- `tail -n5` - shows last five IP addresses
- `grep -oP '(\d+\.){3}\d+'` outputs only IP (one or more decimal numbers with a dot three times and the last octet of IP)

- The result is sending to the `while loop` in which we run all the IP addresses through the `whois` command. 
Command `awk` searches for lines with `Organization` 

- `ss` - is a tool that is used for displaying network socket related information on a Linux system. The tool displays
more detailed information that the netstat command which is used for displaying active socket connections.

### Tasks:
- create README.md and describe how tu use your script
- script parses PID or process name as argument
- number of output lines supposed to be defined by user
- script shows other connection states as defined by user (listening, established, wait)
- script displays clear error messages
- script doesn't depend on launch privileges, it displays a warning

#### Optional tasks:

- script displays the number of connections to each organization 
- script allows you to get other data from the whois output
- script can work with ss, uses other command-line utils

### Manual
Download `script.sh` and run it. You are supposed to specify process name or PID as the script argument. Run this script as root to see more details.

usage:
./script.sh [options] <process>

Options:
-n  <number>          number of lines to output, default value: 5
-a                    all connections, default - only `ESTABLISHED`
-w                    more information, default - only `ORGANIZATION` name
-t                    `ss`, default - `netstat`
<process>             `PROCESS NAME OR PID` - name or PID of process to analyze its connections


### Usage example:

```
script.sh -n 10 -a -w -t chrome
script.sh -n 7 zoom
```
### Result 1:
run `sudo script.sh -n 10 -a -w -t chrome`
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
### Result 2:

run `sudo script.sh -n 6 chrome`
```
+--------------------|--------------------------------------------------+
| Number of connects |  Organization         [ Info ]                  | 
+--------------------|--------------------------------------------------+
      6                 Yandex LLC Network Operations
      4                 Google LLC
      1                 SELECTEL-NOC
      1                 RTB HOUSE Administrators
      1                 Qrator Labs
      1                 GitHub, Inc.
```
### Result 3:

run `script.sh -n 6 chrome`
```
The script is run without root privileges. Some information can't be displayed
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
+--------------------|--------------------------------------------------+
| Number of connects |  Organization         [ Info ]                  | 
+--------------------|--------------------------------------------------+
     21                 Google LLC
      6                 Yandex LLC Network Operations
      1                 Vkontakte Network Control Center
      1                 Twitter Inc.
      1                 SELECTEL-NOC
      1                 RIPE Network Coordination Centre Hetzner Online GmbH - Contact Role
```