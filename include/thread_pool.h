/*************************************************************************
	> File Name: thread_pool.h
	> Author: Yan
	> Mail: winston.yan@outlook.com
	> Created Time: Fri Jan  7 16:48:27 2022
 ************************************************************************/

#ifndef _WINSTON_THREAD_POOL_H
#define _WINSTON_THREAD_POOL_H

#include "common.h"

NS_YAN

class Task {
  public:
    template< typename FUNCTION_T, typename ...ARGS >
    Task(FUNCTION_T func, ARGS ...args) {
        _func = std::bind(func, std::forward<ARGS>(args)...);
    }

    void execute() const {
        _func(); return ;
    }

  private:
    std::function<void()> _func;
};

class ThreadPool {
  private:
    std::shared_ptr<Task> dequeue_task();

    void work_this_thread();

    void stop_this_thread();

  public:
    template< typename FUNCTION_T, typename ...ARGS>
    void enqueue_task(FUNCTION_T func, ARGS ...args) {
        std::unique_lock<std::mutex> lock(_mutex);
        _task_queue.push(std::make_shared<Task>(func, std::forward<ARGS>(args)...));
        _cond.notify_one();
        return ;
    }

    void start();

    void stop();

    ThreadPool(std::size_t thread_num = cfg::THREAD_POOL_DEFAULT_SIZE);
    ~ThreadPool();

  private:
    bool _running{false};
    std::size_t _thread_num;
    std::mutex _mutex;
    std::condition_variable _cond;
    std::vector<std::unique_ptr<std::thread> > _threads;
    std::unordered_map<std::thread::id, bool> _running_map;
    std::queue<std::shared_ptr<Task> > _task_queue;
};

NS_END

#endif /* _WINSTON_THREAD_POOL_H */
