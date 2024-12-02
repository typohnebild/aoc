#include "../include/util.hpp"
#include <algorithm>
#include <cstdlib>
#include <iostream>
#include <ranges>
#include <string>
#include <vector>

using lines_t = std::vector<std::string>;
using number_t = int;

template <typename T> int sgn(T val) { return (T(0) < val) - (val < T(0)); }

auto split_to_ints(std::string_view const &line) {
  return line | std::ranges::views::split(' ') |
         std::ranges::views::transform([](auto &&s) {
           return std::stoi(std::ranges::to<std::string>(s));
         }) |
         std::ranges::to<std::vector<number_t>>();
}

bool is_valid_report(std::vector<number_t> const &report, number_t &fail_pos) {
  number_t last_diff = 0;
  for (number_t i = 0; i < number_t(report.size()) - 1; i++) {
    number_t diff = report[i] - report[i + 1];
    if (std::abs(diff) == 0 || std::abs(diff) > 3) {
      fail_pos = i;
      return false;
    }
    if (i != 0 && sgn(last_diff) != sgn(diff)) {
      fail_pos = i;
      return false;
    }
    last_diff = diff;
  }
  return true;
}
bool is_valid_report(std::vector<number_t> const &report) {
  number_t ignore;
  return is_valid_report(report, ignore);
}

number_t part1(lines_t const &lines) {
  auto x =
      lines |
      std::ranges::views::transform([](auto &&s) { return split_to_ints(s); }) |
      std::ranges::to<std::vector<std::vector<number_t>>>();
  auto y = x | std::ranges::views::transform([](auto &&l) {
             return is_valid_report(l);
           }) |
           std::ranges::to<std::vector<bool>>();
  return std::ranges::count(y, true);
}

number_t part2(lines_t const &lines) {
  number_t ret = 0;
  // number_t line_nr = 0;
  for (auto &line : lines) {
    std::vector<number_t> splitted = split_to_ints(line);
    number_t last_pos = 0;
    bool valid = is_valid_report(splitted, last_pos);
    for (int offset = -1; offset <= 1; offset++) {
      if (last_pos + offset < 0) {
        continue;
      }
      std::vector copy(splitted);
      copy.erase(copy.begin() + last_pos + offset);
      number_t new_last_pos;
      valid = is_valid_report(copy, new_last_pos);
      if (valid) {
        break;
      }
    }
    if (valid) {
      ret++;
    }
  }

  return ret;
}

int main() {
  {
    lines_t lines;
    read_as_list_of_strings("inputs/day2/test.txt", lines);
    std::cout << part1(lines) << std::endl;
  }
  {
    lines_t lines;
    read_as_list_of_strings("inputs/day2/input.txt", lines);
    std::cout << part1(lines) << std::endl;
  }
  {
    lines_t lines;
    read_as_list_of_strings("inputs/day2/test.txt", lines);
    std::cout << part2(lines) << std::endl;
  }
  {
    lines_t lines;
    read_as_list_of_strings("inputs/day2/test2.txt", lines);
    std::cout << part2(lines) << std::endl;
  }
  {
    lines_t lines;
    read_as_list_of_strings("inputs/day2/input.txt", lines);
    std::cout << part2(lines) << std::endl;
  }

  return 0;
}
