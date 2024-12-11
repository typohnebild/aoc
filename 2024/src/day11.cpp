#include "../include/util.hpp"

#include <algorithm>
#include <functional>
#include <iomanip>
#include <iostream>
#include <ranges>
#include <set>
#include <string>
#include <vector>

namespace rng = std::ranges;
namespace rv = std::ranges::views;
using number_t = uint64_t;
using vec_t = std::vector<number_t>;
using lines_t = std::vector<std::string>;

auto split_to_ints(std::string_view const &line) {
  return line | rv::split(' ') | rv::transform([](auto &&s) {
           return std::stoi(std::ranges::to<std::string>(s));
         }) |
         rng::to<std::vector<number_t>>();
}

number_t count_digits(number_t stone) {
  number_t ret = 1;
  while (stone /= 10) {
    ret++;
  }
  return ret;
}

auto blink(number_t stone) {
  if (stone == 0) {
    return vec_t{1};
  }
  number_t digits = count_digits(stone);
  // std::print("{} -> {}\n", stone, digits);
  if (digits % 2 == 0) {
    number_t half_digits = digits / 2;
    number_t first_half = stone / number_t(std::pow(10, half_digits));
    number_t second_half = stone % number_t(std::pow(10, half_digits));
    return vec_t{first_half, second_half};
  }
  return vec_t{stone * number_t(2024)};
}

auto blink_rec(number_t stone, number_t blink) {
  if (blink == 0) {
    return 1;
  }
  if (stone == 0) {
    return blink_rec(1, blink - 1);
  }
  number_t digits = count_digits(stone);
  // std::print("{} -> {}\n", stone, digits);
  if (digits % 2 == 0) {
    number_t half_digits = digits / 2;
    number_t first_half = stone / number_t(std::pow(10, half_digits));
    number_t second_half = stone % number_t(std::pow(10, half_digits));
    return blink_rec(first_half, blink - 1) + blink_rec(second_half, blink - 1);
  }
  return blink_rec(stone * number_t(2024), blink - 1);
}

number_t part1(lines_t const &lines) {
  auto i = split_to_ints(lines[0]);
  number_t const blinks = 25;
  for (number_t b = 0; b < blinks; b++) {
    i = i | rv::transform(blink) | rv::join | rng::to<std::vector>();
  }

  return i.size();
}

number_t part2(lines_t const &lines) {
  auto i = split_to_ints(lines[0]);
  number_t const blinks = 75;
  number_t ret = 0;
  std::unordered_map<number_t, number_t> map;
  for (auto s : i) {
    map[s] = 1;
  }
  for (number_t b = 0; b < blinks; b++) {
    std::unordered_map<number_t, number_t> map_new;
    std::print("{}\n", map);
    for (auto [stone, count] : map) {
      number_t digits = count_digits(stone);
      if (stone == 0) {
        map_new[1] += count;
      } else if (digits % 2 == 0) {
        number_t half_digits = digits / 2;
        number_t first_half = stone / number_t(std::pow(10, half_digits));
        number_t second_half = stone % number_t(std::pow(10, half_digits));
        map_new[first_half] += count;
        map_new[second_half] += count;
      } else {
        map_new[stone * number_t(2024)] += count;
      }
    }
    std::swap(map, map_new);
  }

  for (auto [stone, count] : map) {
    ret += count;
  }
  return ret;
}

int main(int argc, char *argv[]) {

  std::string file_path = "inputs/day11/test.txt";
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
          stopwatch.elapsed_time<unsigned int, std::chrono::microseconds>();
      std::cout << "Part 1: " << res << " in " << time << " μs" << std::endl;
    }
    {
      shino::precise_stopwatch stopwatch;
      auto res2 = part2(lines);
      auto time =
          stopwatch.elapsed_time<unsigned int, std::chrono::microseconds>();
      std::cout << "Part 2: " << res2 << " in " << time << " μs" << std::endl;
    }
  }

  return 0;
}
