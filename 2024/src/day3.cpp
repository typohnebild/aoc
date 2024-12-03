#include "../include/util.hpp"
#include <iostream>
#include <regex>

using number_t = long;

using lines_t = std::vector<std::string>;
number_t part1(lines_t const &lines) {
  number_t ret = 0;
  for (auto &line : lines) {
    // std::cout << line << std::endl;
    std::regex r("mul\\((\\d+),(\\d+)\\)");
    auto start = std::sregex_iterator(line.begin(), line.end(), r);
    auto end = std::sregex_iterator();
    for (auto i = start; i != end; i++) {
      ret += stoi((*i)[1]) * stoi((*i)[2]);
    }
  }
  return ret;
}

number_t part2(lines_t const &lines) {
  number_t ret = 0;
  bool active{true};
  for (auto &line : lines) {
    // std::cout << line << std::endl;
    std::regex r("(mul\\((\\d+),(\\d+)\\))|(do\\(\\))|(don't\\(\\))");
    auto start = std::sregex_iterator(line.begin(), line.end(), r);
    auto end = std::sregex_iterator();
    for (auto i = start; i != end; i++) {
      // std::cout << i->str() << std::endl;
      if (i->str() == "do()") {
        active = true;
      } else if (i->str() == "don't()") {
        active = false;
      } else {
        if (active) {
          ret += stoi((*i)[2]) * stoi((*i)[3]);
        }
      }
    }
  }
  return ret;
}
int main(int argc, char *argv[]) {
  std::string file_path = "inputs/day3/test.txt";
  if (argc == 2) {
    file_path = argv[1];
  }
  {
    lines_t lines;
    read_as_list_of_strings(file_path, lines);
    auto res = part1(lines);
    std::cout << "Part 1: " << res << std::endl;
    auto res2 = part2(lines);
    std::cout << "Part 2: " << res2 << std::endl;
  }

  return 0;
}
