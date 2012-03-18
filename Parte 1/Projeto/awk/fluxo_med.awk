# Como executar o script:
# awk -f fluxo.awk -v FID=(id do fluxo) (arquivo de entrada) > (arquivo de saída)
#
# exemplo:
# awk -f fluxo.awk -v FID=1 out.tr > fluxo.tr
BEGIN {
	highest_packet_id = 0;
	delay_total = 0;
	dropados = 0;
	count = 0;
	count_jitter = 0;
	recvdSize = 0;
}

{
	# Executa este segmento em cada linha do arquivo de entrada
	# Recebe parâmetros

	action = $1;
	time = $2;
	flow_id = $8;
	packet_id = $12;

	# Discrimina monitoramento por fluxo
	if ( flow_id == FID ) {
		if ( packet_id > highest_packet_id ) highest_packet_id = packet_id;
		fid[packet_id] = flow_id;
		service[packet_id] = $5;
		if ( start_time[packet_id] == 0 ) {
			start_time[packet_id] = time;
		}
		# Ignora pacotes dropados
		if ( action == "d" ) {
			dropados++;
		end_time[packet_id] = -1;
		# Inicializa principais vetores
		} else {
			if ( action == "r" ) {
				hop[packet_id] = (hop[packet_id] + 1);
				end_time[packet_id] = time;
				size[packet_id] = $6;
				recvdSize += $6;
			}
		}
	}
}
END {
	for ( packet_id = 0; packet_id <= highest_packet_id; packet_id++ ) {
		start = start_time[packet_id];
		end = end_time[packet_id];
		if ( start < end ) {
			# Resolve número de saltos
			hops = (hop[packet_id] - 1);
			# Resolve delay e jitter
			old_delay = delay;
			delay = 0;
			jitter = 0;
			delay = end - start;
			delay_total = delay_total + delay;
			if ( delay > old_delay ) {
				jitter = delay - old_delay;
			} else {
				jitter = old_delay - delay;
			}
			count_jitter += jitter;
			# Colunas impressas no arquivo de saída
			# printf("%f %f %f %f %s %i %i %i %i %i %i\n", end, delay, jitter, delay_total, start, service[packet_id], size[packet_id], fid[packet_id], hops, packet_id, dropados);
		}
	}
	# Delay_total  delay_medio jitter_medio num_perdas %_perdas
	
	printf("%i %.2f %.2f %.2f %i %.2f %.2f %.2f\n",highest_packet_id, delay_total, delay_total/highest_packet_id, count_jitter/highest_packet_id, dropados, dropados/highest_packet_id, ((recvdSize * 8) /1000) / time, recvdSize/1024);
}