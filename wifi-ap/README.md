# OpenBSD Wireless Access Point Setup

## Steps

* Copy files from repo
* Change EXT_IF for external interface (e.g. sis0)
* Change INT_IF for internal (wireless) interface (e.g. ral0)

## Testing performance

* Start iperf server on AP
```
pfctl -d
iperf -s 
```
* Run iperf from client
```
iperf -c 192.168.189.1 -i 1 -t 60
```
* Enable pf on AP after testing
```
pfctl -e
```

## TODO

* [authpf(8)](https://www.openbsd.org/faq/pf/authpf.html)
