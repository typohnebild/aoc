#include <algorithm>
#include <cctype>
#include <fstream>
#include <iostream>
#include <iterator>
#include <regex>
#include <sstream>
#include <string>
#include <vector>

auto get_first_digit(auto begin, auto end) {

  return std::find_if(begin, end, [](auto c) { return std::isdigit(c); });
}

int getnumber(std::string const &line) {
  std::stringstream ss;
  ss << *get_first_digit(line.begin(), line.end());
  ss << *get_first_digit(line.rbegin(), line.rend());
  return std::stoi(ss.str());
}

int part1(std::string const &filename) {
  std::ifstream input(filename);
  int ret{0};

  for (std::string line; std::getline(input, line);) {
    ret += getnumber(line);
  }
  return ret;
}
constexpr std::string numbers[9] = {"one", "two",   "three", "four", "five",
                                    "six", "seven", "eight", "nine"};

constexpr std::string replacements[9] = {
    "o1e", "t2o", "th3ee", "fo4r", "fi5e", "s6x", "se7en", "ei8ht", "ni9e"};

std::string replacewords(std::string const &line) {
  std::string ret{line};
  for (int i = 0; i < 9; i++) {
    ret = std::regex_replace(ret, std::regex(numbers[i]), replacements[i]);
  }
  return ret;
}

int part2(std::string const &filename) {
  std::ifstream input(filename);
  int ret{0};

  for (std::string line; std::getline(input, line);) {
    ret += getnumber(replacewords(line));
  }
  return ret;
}

int main() {
  std::cout << part1("inputs/day1/test_input1.txt") << std::endl;
  std::cout << part2("inputs/day1/test_input2.txt") << std::endl;
  std::string filename("inputs/day1/input.txt");
  std::cout << part1(filename) << std::endl;
  std::cout << part2(filename) << std::endl;
  exit(0);
}
