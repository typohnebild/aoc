#include "../include/util.hpp"
#include <cctype>
#include <iostream>
#include <string>
#include <vector>

bool is_symbol(char input) { return input != '.' && !isdigit(input); }

bool is_valid(std::vector<std::string> const &lines, int line, int start,
              int end) {
  int line_start = std::max(0, line - 1);
  int line_stop = std::min(int(lines.size()), line + 2);
  int col_start = std::max(0, start - 1);
  int col_stop = std::min(int(lines[0].size()), end + 1);
  // std::cout << "From " << line_start << " to " << line_stop << " " <<
  // col_start
  //           << " to " << col_stop << std::endl;

  // std::cout << "Checking Symbols:" << std::endl;
  for (int i = line_start; i < line_stop; i++) {
    for (int j = col_start; j < col_stop; j++) {
      // std::cout << lines[i][j] << ' ';
      if (is_symbol(lines[i][j])) {
        // std::cout << std::endl;
        return true;
      }
    }
    // std::cout << std::endl;
  }
  // std::cout << std::endl;
  return false;
}

int part1(std::vector<std::string> const &lines) {
  int ret{0};
  int N = lines.size();
  int M = lines[0].size();
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < M;) {
      int end = j;
      if (std::isdigit(lines[i][j])) {
        while (std::isdigit(lines[i][end])) {
          end++;
        }
        int number = std::stoi(lines[i].substr(j, end - j));
        bool valid = is_valid(lines, i, j, end);

        // std::cout << "[" << i << ", " << j << "] = " << number;
        if (valid) {
          // std::cout << " is valid ";
          ret += number;
        }
        // std::cout << "\n";
      }
      j = end + 1;
    }
  }

  return ret;
}
bool isgear(char c) { return c == '*'; }

int getnumber(std::vector<std::string> const &lines, int line, int col) {
  int start = col;
  int stop = col;
  while (std::isdigit(lines[line][start])) {
    start--;

    if (start < 0) {
      break;
    }
  }
  start++;
  while (std::isdigit(lines[line][stop])) {
    stop++;
    if (stop == int(lines[line].size())) {
      break;
    }
  }
  // std::cout << "line=" << line << " Start=" << start << " Stop=" << stop
  //           << std::endl;

  return std::stoi(lines[line].substr(start, stop - start));
}

std::vector<int> findnumbers(std::vector<std::string> const &lines, int line,
                             int col) {
  std::vector<int> numbers;
  int line_start = std::max(0, line - 1);
  int line_stop = std::min(int(lines.size()), line + 2);
  int col_start = std::max(0, col - 1);
  int col_stop = std::min(int(lines[0].size()), col + 2);

  for (int i = line_start; i < line_stop; i++) {
    for (int j = col_start; j < col_stop; j++) {
      if (std::isdigit(lines[i][j])) {
        numbers.push_back(getnumber(lines, i, j));
        // std::cout << "Found Number at [" << i << ", " << j
        //           << "] = " << numbers.back() << std::endl;
        while (std::isdigit(lines[i][j])) {
          j++;
        }
      }
    }
  }
  return numbers;
}

int part2(std::vector<std::string> const &lines) {
  int ret{0};
  int N = lines.size();
  int M = lines[0].size();
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < M; j++) {
      if (isgear(lines[i][j])) {
        auto numbers = findnumbers(lines, i, j);
        if (numbers.size() == 2) {
          ret += numbers[0] * numbers[1];
        }
      }
    }
  }

  return ret;
}

int main() {
  {
    std::vector<std::string> lines;
    read_as_list_of_strings("inputs/day3/test_input.txt", lines);
    std::cout << part1(lines) << std::endl;
    std::cout << part2(lines) << std::endl;
  }
  {
    std::vector<std::string> lines;
    read_as_list_of_strings("inputs/day3/input.txt", lines);
    std::cout << part1(lines) << std::endl;
    std::cout << part2(lines) << std::endl;
  }

  return 0;
}
