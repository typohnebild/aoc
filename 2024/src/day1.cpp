#include "../include/util.hpp"
#include <algorithm>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

void read_line(std::vector<std::string> const &lines, std::vector<int> &left,
               std::vector<int> &right) {
  left.reserve(lines.size());
  right.reserve(lines.size());
  for (auto &line : lines) {
    std::stringstream ss;
    ss << line;
    int l, r;
    ss >> l >> r;
    left.push_back(l);
    right.push_back(r);
  }
}

unsigned long part2(std::vector<std::string> const &lines) {
  std::vector<int> left;
  std::vector<int> right;
  read_line(lines, left, right);
  std::unordered_map<int, int> map;
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
  std::vector<int> left;
  std::vector<int> right;
  read_line(lines, left, right);

  std::sort(left.begin(), left.end());
  std::sort(right.begin(), right.end());
  unsigned long res = 0;
  for (size_t i = 0; i < lines.size(); i++) {
    res += std::abs(left[i] - right[i]);
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
    std::cout << "part1 test: " << res << std::endl;
  }
  {
    std::vector<std::string> lines;
    read_as_list_of_strings("inputs/day1/test.txt", lines);
    auto res = part2(lines);
    std::cout << "part2 test: " << res << std::endl;
  }
  {
    std::vector<std::string> lines;
    read_as_list_of_strings("inputs/day1/input1.txt", lines);
    auto res = part2(lines);
    std::cout << "part2: " << res << std::endl;
  }

  return 0;
}
