#!/usr/bin/env python
#-*- encoding utf-8 -*-

# by tcs5
# Simple sample program using TCI/IP protocol with sockets
# Client side

import socket
import datetime

HOST = '192.168.1.101'
PORT = 50507
connected = True

for i in range(33,100):
	time_array = []
	arq = open('epoch'+str(i), 'w')
	for k in range(10000):
		start = datetime.datetime.now().microsecond
		s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
		s.connect((HOST, PORT))
		msg = 'ACK'
		s.send(msg)
		data = s.recv(1024)
		time_array.append(datetime.datetime.now().microsecond - start) #RTT
	print str(i)
	for j in range(len(time_array)):
		arq.write(str(j)+ " " + str(time_array[j]) + '\n')
	arq.close()
s.close()
