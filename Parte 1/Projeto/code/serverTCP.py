#!/usr/bin/env python
#-*- encoding utf-8 -*-

# by tcs5
# Simple sample program using TCI/IP protocol with sockets
# Server side

import socket

def main():
	HOST = ''
	PORT = 50507

	# socket.socket([family[, type[, proto]]])
	s  = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

	# socket.bind(address)
	s.bind((HOST, PORT))

	# socket.listen(backlog)  backlog = max numero de conexoes em fila
	s.listen(1)

	print 'Server on...'

	# socket.accept() aceita a conexao e retorna (conn, address)
	while True:
		conn, addr = s.accept()
		data = conn.recv(1024)
		if not data: break
		result = resolve(data)
		conn.send(result)
		print 'Send to', addr
	conn.close()


#####################
# auxiliar function #
#####################
def resolve(expr):
	i = 0
	for char in expr:
		if ((char == '+') | (char == '-') | (char == '*') | (char == '/')):
			term1 = expr[:i]
			term2 = expr[i+1:]
			op = expr[i]
		i+=1
		
	if(op == '+'):
		return str(int(term1) + int(term2))
	elif (op == '-'):
		return str(int(term1) - int(term2))
	elif (op == '*'):
		return str(int(term1) * int(term2))
	else:
		return str(int(term1) / int(term2))


if __name__ == '__main__':
	main()
