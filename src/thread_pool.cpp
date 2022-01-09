/*************************************************************************
	> File Name: thread_pool.cpp
	> Author: Yan
	> Mail: winston.yan@outlook.com
	> Created Time: Fri 07 Jan 2022 10:27:15 PM CST
 ************************************************************************/

#include "thread_pool.h"

using namespace MY_NAMESPACE;

std::shared_ptr<Task> ThreadPool::dequeue_task() {
    std::unique_lock<std::mutex> lock(_mutex);
    while (_task_queue.empty()) _cond.wait(lock);
    std::shared_ptr<Task> tp = _task_queue.front();
    _task_queue.pop();
    return tp;
}

void ThreadPool::work_this_thread() {
    std::thread::id id = std::this_thread::get_id();
    _running_map[id] = true;
    while (_running_map[id]) {
        std::shared_ptr<Task> tp = dequeue_task();
        tp->execute();
    }
    return ;
}

void ThreadPool::stop_this_thread() {
    std::thread::id id = std::this_thread::get_id();
    _running_map[id] = false;
    return ;
}

void ThreadPool::start() {
    if (_running == true) return ;
    for (auto i = 0u; i < _thread_num; ++i) {
        _threads[i] = std::make_unique<std::thread>(&ThreadPool::work_this_thread, this);
    }
    _running = true;
    return ;
}

void ThreadPool::stop() {
    if (_running == false) return ;
    for (auto i = 0u; i < _thread_num; ++i)
        enqueue_task(&ThreadPool::stop_this_thread, this);

    for (auto i = 0u; i < _thread_num; ++i)
        _threads[i]->join();

    for (auto i = 0u; i < _thread_num; ++i)
        _threads[i].reset();
    _running = false;
    return ;
}

ThreadPool::ThreadPool(std::size_t thread_num): _thread_num(thread_num), _threads(thread_num) {}

ThreadPool::~ThreadPool() {
    stop();
    while (!_task_queue.empty())
        _task_queue.pop();
}
