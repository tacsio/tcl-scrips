#!/bin/bash

PROTOCOL=TCP
SIZE=7168
CONF=$PROTOCOL'_'$SIZE
FILE=scripts/script6.tcl
SIZES=(1024 1550 2048 3072)

x=0;

rm sumarize.txt

while [ $x != 9  ] 
do
	SIZE=${SIZES[$x]}
	let "x = x + 1"
	
	CONF=$PROTOCOL'_'$SIZE
	sed -i 16d $FILE
	sed -i "16s/^/set packetSize $SIZE\n/" $FILE

	#rm out*
	ns $FILE
	clear
	#echo Número Total de Pacotes Enviados `cat out.tr | grep ^+ | wc -l` > report.txt
	awk -f fluxo_sum.awk -v FID=1 out.tr > report.txt
	awk -f fluxo_med.awk -v FID=1 out.tr | awk '{print $2}' | xargs echo $SIZE   >> medias_delay_$PROTOCOL

	awk -f fluxo_med.awk -v FID=1 out.tr | awk '{print $7}' | xargs echo $SIZE   >> medias_transmissao_$PROTOCOL
	
	awk -f fluxo_med.awk -v FID=1 out.tr | awk '{print $3}' | xargs echo $SIZE   >> jitter_medio_$PROTOCOL

	echo "Tamanho do Pacote: $SIZE bytes" >> sumarize.txt
	cat report.txt >> sumarize.txt
	echo '' >> sumarize.txt

	# 
	awk -f awk/fluxo.awk -v FID=1 out.tr | awk '{print $5" "$2}' > delay_pacotes_tempo_$CONF.txt
	mv delay_pacotes_tempo_$CONF.txt dados/

	# Tempo X Taxa Transmissao
	awk -f awk/fluxo.awk -v FID=1 out.tr | awk '{print $5" "$12}' > banda_tempo_$CONF.txt
	mv banda_tempo_$CONF.txt dados/
done
mv medias_delay_$PROTOCOL dados/
mv medias_transmissao_$PROTOCOL dados/