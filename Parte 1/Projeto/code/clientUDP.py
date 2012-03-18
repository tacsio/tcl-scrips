#!/usr/bin/env python
#-*- coding:utf-8 -*-

import socket
import datetime

HOST='192.168.1.101'
PORT=5005


for i in range(100):
	time_array = []
	arq = open('epoch_udp'+str(i), 'w')
	for k in range(10000):
		start = datetime.datetime.now().microsecond
		s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
		s.sendto('ACK', (HOST, PORT))
		time_array.append(datetime.datetime.now().microsecond - start) #RTT
	print str(i)
	for j in range(len(time_array)):
		arq.write(str(j)+ " " + str(time_array[j]) + '\n')
	arq.close()

			



