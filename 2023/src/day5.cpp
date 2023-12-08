#include "../include/util.hpp"
#include <algorithm>
#include <array>
#include <iostream>
#include <limits>
#include <numeric>
#include <ranges>
#include <sstream>
#include <string>
#include <string_view>
#include <unordered_map>
#include <vector>

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
using number_t = long;

std::vector<number_t> getseeds(std::string_view const line) {
  std::stringstream ss;
  ss << line;
  std::string header;
  ss >> header;
  std::vector<number_t> seeds;
  while (!ss.eof()) {
    number_t tmp;
    ss >> tmp;
    seeds.push_back(tmp);
  }
  return seeds;
}
std::array<number_t, 3> read_line(std::string_view const line) {
  std::array<number_t, 3> ret;
  std::stringstream ss;
  ss << line;
  ss >> ret[0];
  ss >> ret[1];
  ss >> ret[2];
  return ret;
}

using map_t = std::vector<std::array<number_t, 3>>;
using maps_t = std::vector<map_t>;

maps_t get_maps(std::vector<std::string> input) {
  maps_t ret;
  for (size_t i = 1; i < input.size(); i++) {
    if (input[i].ends_with("map:")) {
      ret.emplace_back();
      continue;
    }
    if (input[i] == "\n" || input[i].empty()) {
      continue;
    }
    std::array<number_t, 3> tmp;
    std::stringstream ss;
    ss << input[i];
    ss >> tmp[0] >> tmp[1] >> tmp[2];
    ret.back().push_back(tmp);
  }

  return ret;
}

number_t find_min_location(maps_t const &input, std::vector<number_t> seeds) {
  std::vector<bool> used(seeds.size(), false);

  for (auto &map : input) {
    for (auto &mapping : map) {
      number_t dest = mapping[0];
      number_t src = mapping[1];
      number_t range = mapping[2];

      for (size_t s = 0; s < seeds.size(); s++) {
        auto cur_seed = seeds[s];
        if (!used[s] && src <= cur_seed && cur_seed <= src + range) {
          seeds[s] = dest + (cur_seed - src);
          used[s] = true;
        }
      }
    }
    std::fill(used.begin(), used.end(), false);
  }
  return *std::min_element(seeds.begin(), seeds.end());
}

number_t transform(map_t const &map, number_t input) {
  for (auto const &mapping : map) {
    number_t dest = mapping[0];
    number_t src = mapping[1];
    number_t range = mapping[2];

    if (src <= input && input < src + range) {
      return dest + (input - src);
    }
  }
  return input;
}

number_t apply_all(maps_t const &maps, number_t input) {
  number_t ret = input;
  for (auto const &map : maps) {
    ret = transform(map, ret);
  }
  return ret;
}

number_t part1(std::vector<std::string> const &input) {

  auto seeds = getseeds(input[0]);
  auto maps = get_maps(input);
  return find_min_location(maps, seeds);
}

number_t part1_1(std::vector<std::string> const &input) {

  auto seeds = getseeds(input[0]);
  auto maps = get_maps(input);
  number_t cur_min = std::numeric_limits<number_t>::max();
  for (size_t i = 0; i < seeds.size(); i++) {
    number_t tmp = apply_all(maps, seeds[i]);
    if (tmp < cur_min) {
      cur_min = tmp;
    }
  }
  return cur_min;
}

number_t part2(std::vector<std::string> const &input) {

  auto seeds = getseeds(input[0]);
  auto maps = get_maps(input);
  number_t cur_min = std::numeric_limits<number_t>::max();
  for (size_t i = 0; i < seeds.size(); i += 2) {
    for (number_t j = 0; j <= seeds[i + 1]; j++) {
      number_t tmp = apply_all(maps, seeds[i] + j);
      if (tmp < cur_min) {
        cur_min = tmp;
      }
    }
    std::cout << "Current Min: " << cur_min << std::endl;
  }
  return cur_min;
}

int main() {
  {
    std::vector<std::string> lines;
    read_as_list_of_strings("inputs/day5/test_input1.txt", lines);
    std::cout << part1(lines) << std::endl;
    std::cout << part1_1(lines) << std::endl;
    std::cout << part2(lines) << std::endl;
  }
  {
    std::vector<std::string> lines;
    read_as_list_of_strings("inputs/day5/input.txt", lines);
    std::cout << part1(lines) << std::endl;
    std::cout << part1_1(lines) << std::endl;
    std::cout << part2(lines) << std::endl;
  }

  return 0;
}
