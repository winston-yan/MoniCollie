/*************************************************************************
	> File Name: acceptor.h
	> Author: Yan
	> Mail: winston.yan@outlook.com
	> Created Time: Sat 08 Jan 2022 11:34:46 PM CST
 ************************************************************************/

#ifndef _WINSTON_ACCEPTOR_H
#define _WINSTON_ACCEPTOR_H

#include "common.h"
#include "utils.h"

NS_YAN

class Acceptor {
  public:
	Acceptor(int port);

	friend void set_nonblocking(int);

  private:
	int _listen_port;
	int _listen_fd;
};

NS_END

#endif /* _WINSTON_ACCEPTOR_H */
