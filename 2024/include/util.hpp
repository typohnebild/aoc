#pragma once

#include <fstream>
#include <string>
#include <vector>
#include <array>

bool read_as_list_of_strings(std::string filename,
                             std::vector<std::string> &lines);

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
