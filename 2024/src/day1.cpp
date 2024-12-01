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

std::pair<number_t, number_t> read_line(std::string_view const &line) {
  std::stringstream ss;
  ss << line;
  number_t l, r;
  ss >> l >> r;
  return {l, r};
}

void read_lines(std::vector<std::string> const &lines,
                std::vector<number_t> &left, std::vector<number_t> &right) {
  left.reserve(lines.size());
  right.reserve(lines.size());
  std::vector<std::pair<number_t, number_t>> pairs;
  std::ranges::transform(lines, std::back_inserter(pairs), read_line);
  auto get_first = [](auto &p) { return p.first; };
  auto get_second = [](auto &p) { return p.second; };
  std::ranges::copy(std::ranges::views::transform(pairs, get_first),
                    std::back_inserter(left));
  std::ranges::copy(std::ranges::views::transform(pairs, get_second),
                    std::back_inserter(right));
}

unsigned long part2(std::vector<std::string> const &lines) {
  std::vector<number_t> left;
  std::vector<number_t> right;
  read_lines(lines, left, right);
  std::unordered_map<number_t, number_t> map;
  for (auto r : right) {
    if (auto search = map.find(r); search == map.end()) {
      map.emplace(std::make_pair(r, 0));
    }
    map[r]++;
  }
  unsigned long ret = 0;
  for (auto l : left) {
    if (auto search = map.find(l); search != map.end()) {
      ret += l * map[l];
    }
  }
  return ret;
}

unsigned long part1(std::vector<std::string> const &lines) {
  std::vector<number_t> left;
  std::vector<number_t> right;
  read_lines(lines, left, right);

  std::ranges::sort(left);
  std::ranges::sort(right);
  unsigned long res = 0;
  for (auto elem : std::ranges::views::zip(left, right)) {
    res += std::abs(elem.first - elem.second);
  }
  return res;
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
