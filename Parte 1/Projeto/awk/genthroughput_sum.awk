BEGIN {
       recvdSize = 0
       startTime = 400
       stopTime = 0
       id = 0
       droped = 0
  }
   
  {
             event = $1
             time = $2
             node_id = $3
             pkt_size = $6
   
   if(event == "d"){
	droped++;
   }
  # Store start time
  if (event == "+" && pkt_size >= 512) {
    if (time < startTime) {
             startTime = time
             }
       }
   
  # Update total received packets' size and store packets arrival time
  if (event == "r" && pkt_size >= 512) {
       if (time > stopTime) {
             stopTime = time
             }
       # Rip off the header
       hdr_size = pkt_size % 512
       pkt_size -= hdr_size
       # Store received packet's size
       recvdSize += pkt_size
       }
  }
   
  END {
      printf("Taxa de Transmissão Média[kbps]: %.2f\nQuantidade Total de Informação[Kbytes]: %.2f\nPacotes Perdidos: %i\n",(recvdSize/(stopTime-startTime))*(8/1000), recvdSize/1024, droped);
  }