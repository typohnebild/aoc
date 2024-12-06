#include "../include/util.hpp"
#include <algorithm>
#include <functional>
#include <iostream>
#include <ranges>
#include <sstream>
#include <string>
#include <unordered_map>
#include <utility>
#include <vector>

using number_t = int;
using vec_t = std::vector<number_t>;
namespace rng = std::ranges;
namespace rv = std::ranges::views;

std::pair<number_t, number_t> read_line(std::string_view const &line) {
  std::stringstream ss;
  ss << line;
  number_t l, r;
  ss >> l >> r;
  return {l, r};
}

std::pair<vec_t, vec_t> read_lines(std::vector<std::string> const &lines) {
  auto get_first = [](auto &&p) { return p.first; };
  auto get_second = [](auto &&p) { return p.second; };
  auto left = lines | rv::transform(read_line) | rv::transform(get_first) |
              rng::to<std::vector>();
  auto right = lines | rv::transform(read_line) | rv::transform(get_second) |
               rng::to<std::vector>();
  return {left, right};
}

number_t part2(std::vector<std::string> const &lines) {
  auto [left, right] = read_lines(lines);
  std::unordered_map<number_t, number_t> map;
  rng::for_each(right, [&](auto r) { map[r]++; });
  return rng::fold_left(
      left | rv::transform([&](auto l) { return l * map[l]; }), number_t(0),
      std::plus<>{}

  );
}

number_t part1(std::vector<std::string> const &lines) {
  auto [left, right] = read_lines(lines);
  std::ranges::sort(left);
  std::ranges::sort(right);

  return rng::fold_left(rv::zip(left, right) |
                            rv::transform([](std::pair<number_t, number_t> p) {
                              return std::abs(p.first - p.second);
                            }),
                        number_t(0), std::plus{});
}

int main() {
  {
    std::vector<std::string> lines;
    read_as_list_of_strings("inputs/day1/test.txt", lines);
    auto res = part1(lines);
    std::cout << "part1 test: " << res << std::endl;
  }
  {
    std::vector<std::string> lines;
    read_as_list_of_strings("inputs/day1/input1.txt", lines);
    auto res = part1(lines);
    std::cout << "part 1: " << res << std::endl;
  }
  {
    std::vector<std::string> lines;
    read_as_list_of_strings("inputs/day1/test.txt", lines);
    auto res = part2(lines);
    std::cout << "Part2 test: " << res << std::endl;
  }
  {
    std::vector<std::string> lines;
    read_as_list_of_strings("inputs/day1/input1.txt", lines);
    auto res = part2(lines);
    std::cout << "Part 2: " << res << std::endl;
  }

  return 0;
}
