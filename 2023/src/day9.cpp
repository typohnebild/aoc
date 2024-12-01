#include "../include/util.hpp"
#include <algorithm>
#include <functional>
#include <iostream>
#include <ranges>
#include <sstream>
#include <string>
#include <vector>

using number_t = long;

std::vector<number_t> parse_line(std::string_view const line) {
  std::vector<number_t> ret;
  std::stringstream ss;
  ss << line;
  while (!ss.eof()) {
    number_t tmp;
    ss >> tmp;
    ret.push_back(tmp);
  }
  return ret;
}
std::vector<number_t> getdifferences(std::vector<number_t> const &line) {

  std::vector<number_t> ret(line.size() - 1);
  auto minus = [](auto pair) { return pair[1] - pair[0]; };
  auto pairs = line | std::views::slide(2) | std::views::transform(minus);
  std::ranges::copy(pairs, ret.begin());
  return ret;
}

number_t part1(std::vector<std::string> const &lines) {
  number_t ret = 0;
  for (auto const &line : lines) {
    auto numbers = parse_line(line);
    std::vector<std::vector<number_t>> diffs;
    diffs.push_back(numbers);
    while (std::any_of(diffs.back().begin(), diffs.back().end(),
                       [](auto a) { return a != 0; })) {
      diffs.push_back(getdifferences(diffs.back()));
    }
    for (long i = unsigned(diffs.size()) - 2; i >= 0; i--) {
      diffs[i].push_back(diffs[i].back() + diffs[i + 1].back());
    }
    // std::cout << "Found: " << diffs.front().back() << std::endl;
    ret += diffs.front().back();
  }

  return ret;
}

number_t part2(std::vector<std::string> const &lines) {
  number_t ret = 0;
  for (auto const &line : lines) {
    auto numbers = parse_line(line);
    std::vector<std::vector<number_t>> diffs;
    std::vector<number_t> reversed(numbers.size());
    std::reverse_copy(numbers.begin(), numbers.end(), reversed.begin());
    diffs.push_back(reversed);
    while (std::any_of(diffs.back().begin(), diffs.back().end(),
                       [](auto a) { return a != 0; })) {
      diffs.push_back(getdifferences(diffs.back()));
    }
    for (long i = unsigned(diffs.size()) - 2; i >= 0; i--) {
      diffs[i].push_back(diffs[i].back() + diffs[i + 1].back());
    }
    // std::cout << "Found: " << diffs.front().back() << std::endl;
    ret += diffs.front().back();
  }

  return ret;
}

int main() {
  {
    std::vector<std::string> lines;
    read_as_list_of_strings("inputs/day9/test_input.txt", lines);
    std::cout << "Part 1: " << part1(lines) << std::endl;
    std::cout << "Part 2: " << part2(lines) << std::endl;
  }
  {
    std::vector<std::string> lines;
    read_as_list_of_strings("inputs/day9/input.txt", lines);

    std::cout << "Part 1: " << part1(lines) << std::endl;
    std::cout << "Part 2: " << part2(lines) << std::endl;
  }

  return 0;
}
