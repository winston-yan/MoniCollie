/*************************************************************************
	> File Name: common.h
	> Author: Yan
	> Mail: winston.yan@outlook.com
	> Created Time: Fri Jan  7 16:33:01 2022
 ************************************************************************/

#ifndef _WINSTON_COMMON_H
#define _WINSTON_COMMON_H

#include <functional>
#include <mutex>
#include <condition_variable>
#include <vector>
#include <queue>
#include <thread>
#include <unordered_map>
#include <map>
#include <iostream>
#include <sstream>

#define _BEGIN(ns) namespace ns {
#define _END(ns) }

#define MY_NAMESPACE yan
#define NS_YAN _BEGIN(MY_NAMESPACE)
#define NS_END _END()

_BEGIN(cfg)

static constexpr size_t THREAD_POOL_DEFAULT_SIZE = 2;

_END(cfg) /* end of namespace cfg */

/* COLOR MACROS */

#define COLOR(id) "\033[" #id "m"	
#define CLOSE COLOR(0)

/* front color */

#define FBLACK 	COLOR(30)
#define FRED 	COLOR(31)
#define FGREEN 	COLOR(32)
#define FYELLOW	COLOR(33)
#define FBLUE 	COLOR(34)
#define FPURPLE	COLOR(35)
#define FDGREEN	COLOR(36)
#define FWHITE 	COLOR(37)

/* background color */

#define BBLACK 	COLOR(40)
#define BRED 	COLOR(41)
#define BGREEN 	COLOR(42)
#define BYELLOW	COLOR(43)
#define BBLUE 	COLOR(44)
#define BPURPLE	COLOR(45)
#define BDGREEN	COLOR(46)
#define BWHITE 	COLOR(47)

/* front color highlight */

#define FBLACKHL 	COLOR(90)
#define FREDHL 		COLOR(91)
#define FGREENHL 	COLOR(92)
#define FYELLOWHL	COLOR(93)
#define FBLUEHL 	COLOR(94)
#define FPURPLEHL	COLOR(95)
#define FDGREENHL	COLOR(96)
#define FWHITEHL	COLOR(97)

/* background color highlight */

#define BBLACKHL 	COLOR(100)
#define BREDHL 		COLOR(101)
#define BGREENHL 	COLOR(102)
#define BYELLOWHL	COLOR(103)
#define BBLUEHL 	COLOR(104)
#define BPURPLEHL	COLOR(105)
#define BDGREENHL	COLOR(106)
#define BWHITEHL	COLOR(107)

/* DEFAULT: front color highlight*/

#define  BLACK 	FBLACKHL 
#define  RED 	FREDHL   
#define  GREEN 	FGREENHL 
#define  YELLOW	FYELLOWHL
#define  BLUE 	FBLUEHL  
#define  PURPLE	FPURPLEHL
#define  DGREEN	FDGREENHL
#define  WHITE 	FWHITEHL

/* END OF COLOR MACROS */

#endif /* _WINSTON_COMMON_H */
