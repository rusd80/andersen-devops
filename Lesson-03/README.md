### Lesson 3 homework

## What this one-liner does
This script displays the name of the organizations that own the IP addresses to which the process, passed as a parameter to this script, connects. The process can be specified by name or by proccess ID.
````
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
