/*************************************************************************
	> File Name: logger.h
	> Author: Yan
	> Mail: winston.yan@outlook.com
	> Created Time: Sat Jan  8 10:23:13 2022
 ************************************************************************/

#ifndef _WINSTON_LOGGER_H
#define _WINSTON_LOGGER_H

#include "common.h"

#define LOG(level) (MY_NAMESPACE::LoggerOStream(level, __FILE__, __LINE__, MY_NAMESPACE::MyLogger))
#define LOG_INFO 	LOG(MY_NAMESPACE::LogLevel::INFO	)
#define LOG_WARNING LOG(MY_NAMESPACE::LogLevel::WARNING	)
#define LOG_DEBUG 	LOG(MY_NAMESPACE::LogLevel::DEBUG	)
#define LOG_ERROR	LOG(MY_NAMESPACE::LogLevel::ERROR	)
#define LOG_FATAL	LOG(MY_NAMESPACE::LogLevel::FATAL	)

#define SET_LEVEL(level) (MY_NAMESPACE::MyLogger.set_log_level(level))
#define SET_LEVEL_DEFAULT() SET_LEVEL(MY_NAMESPACE::LogLevel::INFO)

NS_YAN

enum LogLevel {
	INFO,
	WARNING,
	DEBUG,
	ERROR,
	FATAL
};

static std::map<LogLevel, std::string> LogLevelPrompt = {
	{ LogLevel::INFO	, GREEN		"INFO" 		CLOSE },
	{ LogLevel::WARNING	, YELLOW	"WARNING"	CLOSE },
	{ LogLevel::DEBUG	, BLUE		"DEBUG" 	CLOSE },
	{ LogLevel::ERROR	, RED		"ERROR" 	CLOSE },
	{ LogLevel::FATAL	, PURPLE	"FATAL" 	CLOSE }
};

class Logger {
  public:
	void set_log_level(LogLevel level) { m_log_level = level; }

	Logger(LogLevel level = LogLevel::INFO) : m_log_level(level) {}
  
  public:
	LogLevel m_log_level;
	std::mutex m_mutex;
};

class LoggerOStream : public std::ostringstream {
  public:
	LoggerOStream(LogLevel level, std::string filename, int line_no, Logger &logger);

	~LoggerOStream();

  private:
	int _line_no;
	LogLevel _level;
	Logger &_logger;
};

static Logger MyLogger;

NS_END

#endif /* _WINSTON_LOGGER_H */
