#include "../include/util.hpp"

#include <algorithm>
#include <cassert>
#include <functional>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <ranges>
#include <regex>
#include <set>
#include <string>
#include <vector>

namespace rng = std::ranges;
namespace rv = std::ranges::views;
using number_t = int64_t;
using vec_t = std::vector<number_t>;
using lines_t = std::vector<std::string>;
using pos_t = std::pair<number_t, number_t>;

struct Machine {
  std::pair<number_t, number_t> A;
  std::pair<number_t, number_t> B;
  std::pair<number_t, number_t> P;
};

std::ostream &operator<<(std::ostream &os, Machine const &m) {
  os << "[Prize: (" << m.P.first << ", " << m.P.second << ") ";
  os << "A: (" << m.A.first << ", " << m.A.second << ") ";
  os << "B: (" << m.B.first << ", " << m.B.second << ")]";
  return os;
}

Machine parse_machine(auto &&lines) {

  std::regex r("Button [AB]: X([\\+\\-]\\d+), Y([\\+\\-]\\d+)");
  std::smatch m;
  std::regex_search(lines[0], m, r);
  std::pair<number_t, number_t> botton_a = {std::stoi(m[1]), std::stoi(m[2])};
  std::regex_search(lines[1], m, r);
  std::pair<number_t, number_t> botton_b = {std::stoi(m[1]), std::stoi(m[2])};

  std::regex r_price("Prize: X=(\\d+), Y=(\\d+)");
  std::regex_search(lines[2], m, r_price);
  std::pair<number_t, number_t> prize = {std::stoi(m[1]), std::stoi(m[2])};

  return {botton_a, botton_b, prize};
}

number_t solve(Machine const &m) {
  // std::cout << m << std::endl;
  auto [a, c] = m.A;
  auto [b, d] = m.B;
  auto [X, Y] = m.P;
  double det = a * d - b * c;
  double A = (d / det) * X + (-b / det) * Y;
  double B = (-c / det) * X + (a / det) * Y;
  number_t A_press = std::round(A);
  number_t B_press = std::round(B);

  if (A_press * m.A.first + B_press * m.B.first == X &&
      A_press * m.A.second + B_press * m.B.second == Y) {
    return 3 * A_press + B_press;
  } else {
    return 0;
  }
}

number_t part1(lines_t const &lines) {
  auto prices = lines | rv::split("") |
                rv::transform([](auto &&m) { return parse_machine(m); }) |
                rv::transform(solve);
  return rng::fold_left(prices, number_t(0), std::plus{});
}

number_t part2(lines_t const &lines) {
  auto prices = lines | rv::split("") |
                rv::transform([](auto &&m) { return parse_machine(m); }) |
                rv::transform([](auto &&m) {
                  m.P.first += 10000000000000;
                  m.P.second += 10000000000000;
                  return m;
                }) |
                rv::transform(solve);
  return rng::fold_left(prices, number_t(0), std::plus{});
}

int main(int argc, char *argv[]) {

  std::string file_path = "inputs/day13/test.txt";
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
