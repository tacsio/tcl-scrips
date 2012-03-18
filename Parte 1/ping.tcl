set ns [new Simulator]
set fd [open ping.tr w]
$ns trace-all $fd
set nf [open ping.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
$ns duplex-link $n0 $n1 2Mb 10ms DropTail

set tcp [new Agent/TCP]
set sink1 [new Agent/TCPSink]

set ping [new Agent/Ping]
set ping1 [new Agent/Ping]

$ping set packetSize 512
$ping1 set packetSize 512

$ns attach-agent $n0 $tcp
$ns attach-agent $n1 $sink1

$ns connect $tcp $sink1

#$ping attach-agent $tcp
$ns attach-agent $n0 $ping
$ns attach-agent $n1 $ping1

$ns at 0.0 "$ping send"
$ns run
