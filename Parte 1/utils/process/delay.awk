BEGIN {highest_packet_id = 0;}
{
 action = $1;
 time = $2;
 node =$3;
 type = $5;
 packet_id =$12;
  
 if (packet_id > highest_packet_id) {
	highest_packet_id = packet_id;
 }
 #PARA TCP CALCULA O RTT DE CADA ENVIO
 if(type != "cbr"){
	if (action == "+" && $3 == 0) {
		send_time[$11] = time;
	} else if (action == "r" && $4 == 0){
		if(send_time[$11] != 0){
			rtt = time - send_time[$11];
			total_delay = total_delay + rtt;
			printf("%d %.4f \n", packet_id, rtt);
		}
	}
	#PARA UDP CALCULA O TEMPO DE ENVIO ESTIMADO (DEPENDE DA TOPOLOGIA)
  } else {
	if (action == "+" && $3 == 0) {
		send_time[$11] = time;
	} else if(action == "-" && $3 == 1){
		time_estimado = time - send_time[$11]
		total_delay = total_delay + time_estimado;
		printf("%d %.4f \n", $11, time_estimado);
	}
  }
}

END {
print total_delay
# 	packet_no = 0; 
# 	total_delay = 0;
# 	for (packet_id = 0; packet_id <= highest_packet_id; packet_id++){
# 	if ((send_time[packet_id]!=0) && (rcv_time[packet_id]!=0)){
# 		start = send_time[packet_id];
# 		end = rcv_time[packet_id];
# 		packet_duration = end-start;
# 	} else {
# 		packet_duration = -1;
# 	}
# 	if (packet_duration > 0) {
# 	packet_no++;
# 	total_delay = total_delay + packet_duration;
# 	printf("%d %f %f\n", packet_id, total_delay, total_delay/packet_no);
# 	}
# }
  
}