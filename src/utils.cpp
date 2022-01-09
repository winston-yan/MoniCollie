/*************************************************************************
	> File Name: utils.cpp
	> Author: Yan
	> Mail: winston.yan@outlook.com
	> Created Time: Sun 09 Jan 2022 12:29:52 AM CST
 ************************************************************************/

#include "utils.h"

void MY_NAMESPACE::set_nonblocking(int fd) {
	::fcntl(fd, F_SETFL, O_NONBLOCK);
	return ;
}
