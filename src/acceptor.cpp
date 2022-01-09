/*************************************************************************
	> File Name: acceptor.cpp
	> Author: Yan
	> Mail: winston.yan@outlook.com
	> Created Time: Sat 08 Jan 2022 11:34:54 PM CST
 ************************************************************************/

#include "acceptor.h"
#include "logger.h"

using namespace MY_NAMESPACE;

Acceptor::Acceptor(int port)
: _listen_port(port) {
	_listen_fd = ::socket(AF_INET, SOCK_STREAM, 0);

	set_nonblocking(_listen_fd);	
	
	struct ::sockaddr_in server_addr;
	::bzero(&server_addr, sizeof(server_addr));
	server_addr.sin_family = AF_INET;
	server_addr.sin_addr.s_addr = ::htonl(INADDR_ANY);
	server_addr.sin_port = ::htons(port);

	/* only one listen fd for the server, no need to reuse the port */
	// int reuse_on = 1;
	// setsockopt(_listen_fd, SOL_SOCKET, SO_REUSEADDR, &reuse_on, sizeof(reuse_on));

	if (-1 == ::bind(_listen_fd, (struct ::sockaddr *)&server_addr, sizeof(::sockaddr_in)))
		syscall_error_handler("bind");

	if (-1 == ::listen(_listen_fd, cfg::PENDING_CONN_QUEUE_SIZE))
		syscall_error_handler("listen");
	
	LOG_INFO << "Listening on port [" 
		<< GREEN << _listen_port << CLOSE
		<< "], file descriptor [" 
		<< GREEN << _listen_fd << CLOSE 
		<< "] ...";
}