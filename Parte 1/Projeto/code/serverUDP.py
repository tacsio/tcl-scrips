#!/usr/bin/env python
# -*- coding:utf-8 -*-

import socket

HOST='localhost'
PORT=5005

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.bind((HOST, PORT))

while True:
	data, addr = s.recvfrom(1024)
	print 'Received message: ', data