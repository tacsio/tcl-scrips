BEGIN {
       recvdSize = 0
       startTime = 400
       stopTime = 0
       id = 0
       printf("%.4f, %.2f\n",0, 0)
       
  }
   
  {
             event = $1
             time = $2
             node_id = $3
             pkt_size = $6
   
  # Store start time
  if (event == "+") {
    if (time < startTime) {
             startTime = time
             }
       }
   
  # Update total received packets' size and store packets arrival time
  if (event == "r") {
       if (time > stopTime) {
             stopTime = time
             }
       # Rip off the header
       hdr_size = pkt_size % 512
       pkt_size -= hdr_size
       # Store received packet's size
       recvdSize += pkt_size
       }
     # id += 1
     
     
       #if(stopTime-startTime > 0){
 		printf("%.4f, %.2f\n",time, (recvdSize/(stopTime-startTime))*(8/1000))
    #   } else {
     #    printf("%.4f, %.2f\n",time, 0)
      # }
  }
   
  END {
      # printf("Average Throughput[kbps] = %.2f\t\t StartTime=%.2f\tStopTime=%.2f\n",(recvdSize/(stopTime-startTime))*(8/1000),startTime,stopTime)
  }
