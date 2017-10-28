::cisco::eem::event_register_none maxrun 180

namespace import ::cisco::eem::*

namespace import ::cisco::lib::*

#
# Configure list of targets below.  Every test will use the list below as target destinations
# I've created multiple smaller lists to make it more readable.  Those lists are combined into
# on long list at the end.   
#
set targetList1 {1.1.1.1 2.2.2.2 3.3.3.3}
set targetNames1 {Test-Rtr-1 Test-Rtr-2 Test-Rtr-3}
#
set targetList2 {4.4.4.4 5.5.5.5 6.6.6.6}
set targetNames2 {Test-Rtr-4 Test-Rtr-5 Test-Rtr-6}
#
set targetList3 {7.7.7.7 8.8.8.8 9.9.9.9}
set targetNames3 {Test-Rtr-7 Test-Rtr-8 Test-Rtr-9}
#
set targetList [concat $targetList1 $targetList2 $targetList3]
set targetNames [concat $targetNames1 $targetNames2 $targetNames3]
#
#
#
# Open CLI connection and put us into enable mode
#
#
#
if { [catch {cli_open} result] } {
    error $result $errorInfo
} else {
    array set cli1 $result
    }

if { [catch {cli_exec $cli1(fd) "enable"} _cli_result] } {
    error $_cli_result $errorInfo
}
#
#
#
# Ping Targets
#
#
#
puts "\n\n\n************  Ping Targets  ************\n"
# The countp counter iterates on each target, we use it to reference the names so we don't have to
# remember what all the IP addresses reference
set countp 0
foreach ip $targetList {
	# ping twice to ensure ARP has time to resolve
	if { [catch {cli_exec $cli1(fd) "ping $ip re 2"} _cli_result] } {
	    error $_cli_result $errorInfo
	}
	# regex the output to see if we had succes in the two pings
	if { [regexp {.!} $_cli_result] } {
		# extract the latence from the output - our output will be simpler than a bunch of . and !s.
		regexp "(\[0-9]{1,4}/\[0-9]{1,4}/\[0-9]{1,4}.ms)" $_cli_result] latency
		# print the success result
		puts "[lindex $targetNames $countp] - Reachable - $latency"
	} else {
		# print the failure result
		puts "[lindex $targetNames $countp] - ** OFFLINE **"
	}
	# increase our conter every iteration
	incr countp
}
#
#
#
# Traceroute To Targets
#
#
#
puts "\n\n\n\n************  Trace Targets  ************\n\n"
# same as above counter but this time for traceroute targets
set countt 0
foreach tr $targetList {
	# This is the tracroute command we send.  This may need to be modified based off of platform
	if { [catch {cli_exec $cli1(fd) "traceroute $tr timeout 1 probe 1 ttl 1 10 numeric"} _cli_result] } {
	    error $_cli_result $errorInfo
	}
	# we just want the standrad output here - but we are adding the name in so reference is easier
	puts "**** $tr - [lindex $targetNames $countt] **** \n $_cli_result\n"
	incr countt
}
#
#
#
# Generic Routing Information Output
# We needed to ensure neighbors stayed up/re-established so this is a simple check for that.
#
#
#
puts "\n\n\n\n************  Routing Information  ************\n\n"
if { [catch {cli_exec $cli1(fd) "show ip bgp summary"} _cli_result] } {
    error $_cli_result $errorInfo
}
puts "IP BGP Summary:\n$_cli_result\n\n"


if { [catch {cli_exec $cli1(fd) "show ip eigrp neighbor"} _cli_result] } {
    error $_cli_result $errorInfo
}
puts "IP EIGRP Neighbors:\n$_cli_result\n\n"

# Clean up.
catch {cli_close $cli1(fd) $cli1(tty_id)}