#include "../include/util.hpp"
#include <algorithm>
#include <array>
#include <iostream>
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

struct map {
  int operator[](int idx) {
    auto it = map.find(idx);
    if (it != map.end()) {
      return it->second;
    }
    return idx;
  }

  std::unordered_map<int, int> map;
};

std::vector<int> getseeds(std::string_view const line) {
  std::stringstream ss;
  ss << line;
  std::string header;
  ss >> header;
  std::vector<int> seeds;
  while (!ss.eof()) {
    int tmp;
    ss >> tmp;
    seeds.push_back(tmp);
  }
  return seeds;
}
std::array<int, 3> read_line(std::string_view const line) {
  std::array<int, 3> ret;
  std::stringstream ss;
  ss << line;
  ss >> ret[0];
  ss >> ret[1];
  ss >> ret[2];
  return ret;
}

int part1(std::vector<std::string> const &input) {

  auto seeds = getseeds(input[0]);
  // for (auto seed : seeds) {
  //   std::cout << seed << ' ';
  // }
  // std::cout << std::endl;
  std::vector<map> maps;
  for (int i = 1; i < int(input.size()); i++) {
    if (input[i].ends_with("map:")) {
      maps.emplace_back(map{});
      continue;
    }
    if (input[i] == "\n" || input[i].empty()) {
      continue;
    }
    auto line = read_line(input[i]);
    std::cout << "line" << i << ": " << input[i] << "->" << line[0] << " "
              << line[1] << " " << line[2] << std::endl;
  //   int diff = line[1] - line[0];
  //   std::vector<int> lhs(line[2]);
  //   std::iota(lhs.begin(), lhs.end(), line[0]);
  //   std::cout << lhs << std::endl;
  //
  //   std::vector<int> rhs(line[2]);
  //   std::ranges::rotate_copy(lhs, lhs.end() - diff, rhs.begin());
  //   std::cout << rhs << std::endl;
  //
  //   for (auto l = lhs.begin(); auto r : rhs) {
  //     maps.back().map.insert({*(l++), r});
  //   }
  //
    for (int j = 0; j < line[2]; j++) {
      maps.back().map.insert({line[1] + j, line[0] + j});
    }
  }
  for (int i = 0; i < int(seeds.size()); i++) {
    std::cout << seeds[i] << ' ';
    for (auto &cur_map : maps) {
      seeds[i] = cur_map[seeds[i]];
      std::cout << seeds[i] << ' ';
    }
    std::cout << std::endl;
  }

  return *std::min_element(seeds.begin(), seeds.end());
}

int main() {
  {
    std::vector<std::string> lines;
    read_as_list_of_strings("inputs/day5/test_input1.txt", lines);
    std::cout << part1(lines) << std::endl;
  }
  {
    std::vector<std::string> lines;
    read_as_list_of_strings("inputs/day5/input.txt", lines);
    std::cout << part1(lines) << std::endl;
  }

  return 0;
}
