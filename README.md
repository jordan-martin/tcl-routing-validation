# tcl-routing-validation
An EEM-TCL script to validate reachability and transit path during network changes.

This script was created to do automated information collection at multiple phases throughout a large network migration. It was placed on multiple routers and switches around the network and run at each validation step, to verify that reachability had been maintained and that I had not introduced any suboptimal routing paths.

# Why EEM-TCL?
Initially the plan was to just use TCL to do the job, but traceroute lacks consistency across platforms.  On some it worked, and on some it didn't. I needed the validation script to work on any device I needed to run it from, regardless of platform, so I modified the initial script to be a variant using EEM-TCL. This worked incredibly well across router and switch platforms running both IOS and IOS-XE.

# Registration
If you're unfamiliar with how EEM-TCL works, there are a couple extra steps you'll need to do to allow it to run. The process for installing this script is below:

1) Modify the script to your needs and upload to the flash storage on the device.  It is recommended to use a subdirectory, as we have to define which area of the filesystem to look in for EEM policies. I've chosen **flash:/policies/{file-name}**

2) Register the directory your created as the EEM TCL policy folder.  Enter the following command in configuration mode: 

**```Source-Router(config)#event manager directory user policy flash:/policies```**

3) Register the TCL script as a policy in EEM. To do so enter the following command in configuration mode:  

**```Source-Router(config)#event manager policy {file-name}```**

4) To run your script, enter the following command from enable mode:  

**```Source-Router#event manager run <file-name>```**

**Note** Something else that you probably want to do when running this script is setting the term length to 0 so you don't have to keep prompting additional output.

**```Source-Router#term length 0```**

# Sample Output
```
Random-Router#event manager run val_all.tcl


************  Ping Targets  ************

Test-Rtr-1 - Reachable - 1/1/1 ms
Test-Rtr-2 - Reachable - 1/1/1 ms
Test-Rtr-3 - Reachable - 1/1/1 ms
Test-Rtr-4 - Reachable - 1/1/1 ms
Test-Rtr-5 - Reachable - 1/1/1 ms
Test-Rtr-6 - Reachable - 1/1/1 ms
Test-Rtr-7 - ** OFFLINE **"
Test-Rtr-8 - Reachable - 1/1/1 ms
Test-Rtr-9 - Reachable - 1/1/1 ms




************  Trace Targets  ************


**** 1.1.1.1 - Test-Rtr-1 **** 
 
Type escape sequence to abort.
Tracing the route to 1.1.1.1
VRF info: (vrf in name/id, vrf out name/id)
  1 10.10.10.10 0 msec
  2 1.1.1.1 1 msec

**** 2.2.2.2 - Test-Rtr-2 **** 
 
Type escape sequence to abort.
Tracing the route to 2.2.2.2
VRF info: (vrf in name/id, vrf out name/id)
  1 10.10.10.10 0 msec
  2 2.2.2.2 1 msec

**** 3.3.3.3 - Test-Rtr-3 **** 
 
Type escape sequence to abort.
Tracing the route to 3.3.3.3
VRF info: (vrf in name/id, vrf out name/id)
  1 10.10.10.10 0 msec
  2 3.3.3.3 1 msec

**** 4.4.4.4 - Test-Rtr-4 **** 
 
Type escape sequence to abort.
Tracing the route to 4.4.4.4
VRF info: (vrf in name/id, vrf out name/id)
  1 10.10.10.10 0 msec
  2 4.4.4.4 1 msec

**** 5.5.5.5 - Test-Rtr-5 **** 
 
Type escape sequence to abort.
Tracing the route to 5.5.5.5
VRF info: (vrf in name/id, vrf out name/id)
  1 10.10.10.10 0 msec
  2 5.5.5.5 1 msec

**** 6.6.6.6 - Test-Rtr-6 **** 
 
Type escape sequence to abort.
Tracing the route to 6.6.6.6
VRF info: (vrf in name/id, vrf out name/id)
  1 10.10.10.10 0 msec
  2 6.6.6.6 1 msec

**** 7.7.7.7 - Test-Rtr-7 **** 
 
Type escape sequence to abort.
Tracing the route to 7.7.7.7
VRF info: (vrf in name/id, vrf out name/id)
  1 10.10.10.10 0 msec
  2 *
  3 *
  4 *
  5 *
  6 *
  7 *
  8 *
  9 *
  10 *

**** 8.8.8.8 - Test-Rtr-8 **** 
 
Type escape sequence to abort.
Tracing the route to 8.8.8.8
VRF info: (vrf in name/id, vrf out name/id)
  1 10.10.10.10 0 msec
  2 8.8.8.8 1 msec

**** 9.9.9.9 - Test-Rtr-9 **** 
 
Type escape sequence to abort.
Tracing the route to 9.9.9.9
VRF info: (vrf in name/id, vrf out name/id)
  1 10.10.10.10 0 msec
  2 9.9.9.9 1 msec





************  Routing Information  ************


IP BGP Summary:
% BGP not active


IP EIGRP Neighbors:

EIGRP-IPv4 Neighbors for AS(1000)
H   Address                 Interface              Hold Uptime   SRTT   RTO  Q  Seq
                                                   (sec)         (ms)       Cnt Num
0   10.10.10.10           Gi0/0/0                  12 3d05h       1   100  0  210395528
```
