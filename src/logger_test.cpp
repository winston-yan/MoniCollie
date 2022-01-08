/*************************************************************************
	> File Name: logger_test.cpp
	> Author: Yan
	> Mail: winston.yan@outlook.com
	> Created Time: Sat 08 Jan 2022 04:32:06 PM CST
 ************************************************************************/

#include "logger.h"
#include "thread_pool.h"

_BEGIN(logger_test)

void worker(int a, int b, int c) {
	LOG_INFO << a << " " << b << " " << c;
	return ;
}

int main() {

	SET_LEVEL(MY_NAMESPACE::LogLevel::DEBUG);
	LOG_INFO << "Informational messages that might make sense to end users and system administrators, and highlight the progress of the application to continue running.";
    LOG_WARNING << "Potentially harmful situations of interest to end users or system managers that indicate potential problems.";
    LOG_DEBUG << "Relatively detailed tracing used by application developers. The exact meaning of the three debug levels varies among subsystems.";
    LOG_ERROR << "Error events of considerable importance that will prevent normal program execution, but might still allow the application to continue running.";
    LOG_FATAL << "Very severe error events that might cause the application to terminate.";
	SET_LEVEL_DEFAULT();
	
	using MY_NAMESPACE::ThreadPool;
    ThreadPool tp;
	tp.start();
    for (int i = 0; i < 100; i++) {
        tp.enqueue_task(logger_test::worker, i, 2 * i, 3 * i);
    }
    tp.stop();
	

	return 0;
}

_END(logger_test)

int main() {
	logger_test::main();
	return 0;
}