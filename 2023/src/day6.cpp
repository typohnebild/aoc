#include "../include/util.hpp"
#include <algorithm>
#include <chrono>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <sstream>

using number_t = unsigned long;
// using number_t = __uint128_t;

std::ostream &operator<<(std::ostream &os, __uint128_t x) {
  if (x >= 10) {
    os << x / 10;
  }
  os << static_cast<unsigned>(x % 10);

  return os;
}

template <typename T> T race(T time, T distance) {
  // std::cout << "Time: " << time << " " << distance << std::endl;
  T ret = 0;
  for (T i = 1; i < time; i++) {
    if (i * (time - i) > distance) {
      ret++;
    }
  }

  return ret;
}

auto parse_input(std::vector<std::string> const &lines) {
  std::vector<std::pair<number_t, number_t>> pairs;
  std::stringstream ss1;
  std::stringstream ss2;
  ss1 << lines[0];
  ss2 << lines[1];
  std::string discard;
  ss1 >> discard;
  ss2 >> discard;
  while (!ss1.eof()) {
    number_t time;
    number_t distance;
    ss1 >> time;
    ss2 >> distance;
    pairs.push_back({time, distance});
  }
  return pairs;
}
number_t part1(std::vector<std::pair<number_t, number_t>> const &pairs) {
  auto check_race = [](std::pair<number_t, number_t> const &pair) {
    return race(pair.first, pair.second);
  };
  std::vector<number_t> races(pairs.size());
  std::transform(pairs.begin(), pairs.end(), races.begin(), check_race);
  // std::cout << "Races: " << races << std::endl;
  return std::transform_reduce(pairs.begin(), pairs.end(), number_t(1),
                               std::multiplies{}, check_race);
  // return std::accumulate(races.begin(), races.end(), 1, std::multiplies{});
}

int main() {
  // std::cout << race(7, 9) << std::endl;
  // std::cout << race(15, 40) << std::endl;
  // std::cout << race(30, 200) << std::endl;
  {
    std::vector<std::string> lines;
    read_as_list_of_strings("inputs/day6/input1.txt", lines);
    auto res = part1(parse_input(lines));
    std::cout << "Part 1: " << res << std::endl;
  }

  std::cout << "Part 2 test: " << race(71530, 940200) << std::endl;

  auto start_time = std::chrono::high_resolution_clock::now();
  std::cout << "Part 2: " << race<unsigned long>(50748685, 242101716911252)
            << std::endl;

  auto end_time = std::chrono::high_resolution_clock::now();
  std::chrono::duration<double> elapsed = end_time - start_time;
  std::cout << "Elapsed: " << elapsed.count() << std::endl;
  return 0;
}
