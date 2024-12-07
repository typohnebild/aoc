#include "../include/util.hpp"

#include <algorithm>
#include <functional>
#include <iostream>
#include <ranges>
#include <string>
#include <vector>

namespace rng = std::ranges;
namespace rv = std::ranges::views;
using number_t = unsigned long long;
using vec_t = std::vector<number_t>;
using lines_t = std::vector<std::string>;
using pos_t = std::pair<number_t, number_t>;

auto split_line(std::string_view line) {
  return line | rv::split(' ') | rv::transform([](auto &&s) {
           return std::stoull(
               s | rv::take_while([](auto &&c) { return c != ':'; }) |
               rng::to<std::string>());
         }) |
         rng::to<std::vector>();
}

number_t operator3(number_t x, number_t y) {
  number_t n = 1;
  while (n <= y) {
    n *= number_t(10);
  }
  return x * n + y;
}

bool eval(std::span<number_t> line, number_t target, number_t cur, auto &ops) {
  if (line.empty()) {
    return cur == target;
  }
  if (cur > target) {
    return false;
  }

  auto x = ops |
           rv::transform([&](auto &&op) { return op(cur, line.front()); }) |
           rv::transform([&](auto new_cur) {
             return eval(line.subspan(1), target, new_cur, ops);
           }) |
           rv::filter([](auto &&x) { return x; });

  return !x.empty();
}

void eval(std::span<number_t> line, std::vector<vec_t> &results,
          number_t target, auto &&ops) {
  if (line.empty()) {
    return;
  }
  results.push_back(results.back() | rv::transform([&](auto &&r) {
                      return ops | rv::transform([&](auto &&op) {
                               return op(r, line.front());
                             }) |
                             rv::filter([&](auto v) { return v <= target; });
                    }) |
                    rv::join | rng::to<std::vector>());
  eval(line.subspan(1), results, target, ops);
}

bool is_result(vec_t &line, auto &ops) {
  std::vector<vec_t> results;
  results.push_back({line[1]});
  std::span operands{line.begin() + 2, line.end()};
  // eval(operands, results, line[0], ops);
  // return rng::contains(results.back(), line[0]);
  return eval(operands, line[0], line[1], ops);
}

number_t part(lines_t &lines, auto &ops) {
  return rng::fold_left(
      lines | rv::transform(split_line) | rv::filter([&](auto &&l) {
        return is_result(l, ops);
      }) | rv::transform([](auto &&c) { return c[0]; }),
      number_t(0), std::plus<number_t>{});
}

number_t part1(lines_t &lines) {
  std::vector<std::function<number_t(number_t, number_t)>> ops = {
      [](number_t lhs, number_t rhs) { return lhs + rhs; },
      [](number_t lhs, number_t rhs) { return lhs * rhs; },
  };
  return part(lines, ops);
}

number_t part2(lines_t &lines) {
  std::vector<std::function<number_t(number_t, number_t)>> ops = {
      [](number_t lhs, number_t rhs) { return lhs + rhs; },
      [](number_t lhs, number_t rhs) { return lhs * rhs; },
      [](number_t lhs, number_t rhs) { return operator3(lhs, rhs); }};
  return part(lines, ops);
}

int main(int argc, char *argv[]) {

  std::string file_path = "inputs/day7/test.txt";
  if (argc == 2) {
    file_path = argv[1];
  }
  {
    lines_t lines;
    read_as_list_of_strings(file_path, lines);

    {

      shino::precise_stopwatch stopwatch;
      auto res = part1(lines);
      auto time =
          stopwatch.elapsed_time<unsigned int, std::chrono::milliseconds>();
      std::cout << "Part 1: " << res << " in " << time << " ms" << std::endl;
    }
    {
      shino::precise_stopwatch stopwatch;
      auto res2 = part2(lines);
      auto time =
          stopwatch.elapsed_time<unsigned int, std::chrono::milliseconds>();
      std::cout << "Part 2: " << res2 << " in " << time << " ms" << std::endl;
    }
  }

  return 0;
}
