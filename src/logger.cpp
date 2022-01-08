/*************************************************************************
	> File Name: logger.cpp
	> Author: Yan
	> Mail: winston.yan@outlook.com
	> Created Time: Sat Jan  8 12:31:12 2022
 ************************************************************************/

#include "logger.h"

using namespace MY_NAMESPACE;

LoggerOStream::LoggerOStream(LogLevel level, std::string filename, int line_no, Logger &logger)
: _line_no(line_no), _level(level), _logger(logger) {
	std::ostringstream &os_buffer = *this;
	os_buffer << LogLevelPrompt[level] << "\t [" << std::move(filename) << " : " << line_no << "] ";
}

LoggerOStream::~LoggerOStream() {
	if (_level < _logger.m_log_level) return ;
	std::unique_lock<std::mutex> lock(_logger.m_mutex);
	std::cerr << this->str() << std::endl;
}



