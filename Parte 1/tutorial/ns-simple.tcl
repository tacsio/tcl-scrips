# Cria um objeto simulator
set ns [new Simulator]

# Cores para os fluxos de dados ($ns color fid color) - fid: id do fluxo
$ns color 1 Blue
$ns color 2 Red

#Trace file
set f [open out.tr w]
$ns trace-all $f

set nf [open out.nam w]
# diz ao simulador para gravar os caminhos da simulação no formato de entrada do NAM
# $ns namtrace-all file-descriptor
$ns namtrace-all $nf

#Finish procedure
proc finish {} {
	global ns nf
	$ns flush-trace
	#Close file
	close $nf
	
	global ns f
	$ns flush-trace
	close $f
	#Executa animador
	exec nam out.nam &
	exit 0
}

# Topology
#               n0 (tcp) (ftp)
# 2mbps, 10ms    \                           
#                 \     1.7 mbps, 20ms     (sink)
#                 n2 ----------------- n3 (null)
# 2mbps, 10ms     /
#                /
#               n1 (udp) (cbr) pkt size: 1kbyte, rate 1mbps
#             
#
#           +ftp                           -ftp
#    +cbr                                        -cbr
#  +--------+---------+----------+---------+-----+----+ 
#  0        1         2          3         4    4.5   5

#Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

#Create links ($ns duplex-link node1 node2 bandwidth delay queue-type)
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.7Mb 20ms DropTail

$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right

#Tamanho da Fila (n2-n3) ($ns queue-limit node1 node2 number)
$ns queue-limit $n2 $n3 10

#Monitor da fila (n2-n3)
$ns duplex-link-op $n2 $n3 queuePos 0.5

#Setup TCP
#Agente n0
set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $n0 $tcp
#Agente n3 (receiver)
set sink [new Agent/TCPSink]
# $ns attach-agent node agent
$ns attach-agent $n3 $sink
#Conexao entre eles ($ns connect agent1 agent2)
$ns connect $tcp $sink
$tcp set fid_ 1

#Setup FTP over TCP
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

#Setup UDP 
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp

set null [new Agent/Null]
$ns attach-agent $n3 $null

#Conxao entre eles
$ns connect $udp $null
$udp set fid_ 2

#Setup CBR(Constant bit-rate)  over UDP
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 100
$cbr set rate_ 1mb
$cbr set random_ false

#Programando eventos
$ns at 0.1 "$cbr start"
$ns at 1.0 "$ftp start"
$ns at 4.0 "$ftp stop"
$ns at 4.5 "$cbr stop"

#desligar agentes Tcp e Sink
$ns at 4.5 "$ns detach-agent $n0 $tcp ; $ns detach-agent $n3 $sink"

#chamar metodo finish
$ns at 5.0 "finish"

#Print CBR packet size and interval
puts "CBR packet size = [$cbr set packet_size_]"
puts "CBR interval = [$cbr set interval_]"

#Executar simulacao
$ns run
