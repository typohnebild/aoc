#include "../include/util.hpp"

#include <iostream>
#include <string>
#include <vector>
using number_t = int;
using vec_t = std::vector<number_t>;
using lines_t = std::vector<std::string>;
constexpr std::string target = "XMAS";
const std::vector<std::pair<number_t, number_t>> dirs = {
    {0, 1}, {0, -1}, {1, 0}, {-1, 0}, {1, 1}, {-1, 1}, {1, -1}, {-1, -1},
};

bool valid_index(number_t i_idx, number_t j_idx, number_t N, number_t M) {
  return 0 <= i_idx && i_idx < N && 0 <= j_idx && j_idx < M;
}
std::string targets[2] = {"MAS", "SAM"};

number_t part2(lines_t const &lines) {
  number_t N = lines.size();
  number_t M = lines[0].size();
  number_t ret = 0;
  for (number_t i = 0; i < N; i++) {
    for (number_t j = 0; j < M; j++) {

      for (auto &t : targets) {
        if (lines[i][j] == t[0]) {
          bool valid = true;
          for (number_t k = 1; k < number_t(t.size()); k++) {
            number_t i_idx = i + k;
            number_t j_idx = j + k;
            if (!(valid_index(i_idx, j_idx, N, M) &&
                  lines[i_idx][j_idx] == t[k])) {
              valid = false;
              break;
            }
          }
          if (valid) {
            for (auto &t2 : targets) {
              valid = true;
              for (number_t k = 0; k < number_t(t2.size()); k++) {
                number_t i_idx = i + k;
                number_t j_idx = j + 2 - k;
                if (!(valid_index(i_idx, j_idx, N, M) &&
                      lines[i_idx][j_idx] == t2[k])) {
                  valid = false;
                  break;
                }
              }
              if (valid) {
                break;
              }
            }
          }
          if (valid) {
            std::print("Found {} {}\n", i, j);
            ret++;
          }
        }
      } // targets
    }
  }
  return ret;
}

number_t part1(lines_t const &lines) {
  number_t N = lines.size();
  number_t M = lines[0].size();
  number_t ret = 0;
  for (number_t i = 0; i < N; i++) {
    for (number_t j = 0; j < M; j++) {
      if (lines[i][j] == target[0]) {
        for (auto dir : dirs) {
          bool valid = true;
          for (number_t k = 1; k < number_t(target.size()); k++) {
            number_t i_idx = i + k * std::get<0>(dir);
            number_t j_idx = j + k * std::get<1>(dir);
            if (!(0 <= i_idx && i_idx < N && 0 <= j_idx && j_idx < M &&
                  lines[i_idx][j_idx] == target[k])) {
              // std::print("Stop at {} {} k: {} dir: {}\n", i_idx, j_idx, k,
              // dir);
              valid = false;
              break;
            }
          }
          if (valid) {
            ret++;
          }
        }
      }
    }
  }
  return ret;
}
int main(int argc, char *argv[]) {

  std::string file_path = "inputs/day4/test.txt";
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
