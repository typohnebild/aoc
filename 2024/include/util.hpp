#pragma once

#include <array>
#include <atomic>
#include <chrono>
#include <string>
#include <vector>

bool read_as_list_of_strings(std::string filename,
                             std::vector<std::string> &lines);

template <typename T>
std::ostream &operator<<(std::ostream &os, std::vector<T> vec) {
  for (auto &e : vec) {
    os << e << ' ';
  }
  return os;
}
template <typename T, size_t n>
std::ostream &operator<<(std::ostream &os, std::array<T, n> arr) {
  for (auto &e : arr) {
    os << e << ' ';
  }
  return os;
}

namespace shino {
template <typename Clock = std::chrono::high_resolution_clock> class stopwatch {
  const typename Clock::time_point start_point;

public:
  stopwatch() : start_point(Clock::now()) {}

  template <typename Rep = typename Clock::duration::rep,
            typename Units = typename Clock::duration>
  Rep elapsed_time() const {
    std::atomic_thread_fence(std::memory_order_relaxed);
    auto counted_time =
        std::chrono::duration_cast<Units>(Clock::now() - start_point).count();
    std::atomic_thread_fence(std::memory_order_relaxed);
    return static_cast<Rep>(counted_time);
  }
};

using precise_stopwatch = stopwatch<>;
using system_stopwatch = stopwatch<std::chrono::system_clock>;
using monotonic_stopwatch = stopwatch<std::chrono::steady_clock>;
} // namespace shino
