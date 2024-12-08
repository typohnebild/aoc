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
using number_t = long;
using vec_t = std::vector<number_t>;
using lines_t = std::vector<std::string>;

constexpr char EMPTY{'.'};

struct Position {
  number_t x;
  number_t y;
  Position operator+(Position const &rhs) const {
    return {x + rhs.x, y + rhs.y};
  }
  Position operator-(Position const &rhs) const {
    return {x - rhs.x, y - rhs.y};
  }
  Position &operator+=(Position const &rhs) {
    x += rhs.x;
    y += rhs.y;
    return *this;
  }
  Position operator*(number_t scalar) const { return {x * scalar, y * scalar}; }
  bool operator<(Position const &rhs) const {
    return x < rhs.x || (x == rhs.x && y < rhs.y);
  }
};

std::ostream &operator<<(std::ostream &os, Position const &p) {
  os << "(" << p.x << ", " << p.y << ")";
  return os;
}

struct Antena {
  Position pos;
  char frequency{EMPTY};
};

std::ostream &operator<<(std::ostream &os, Antena const &a) {
  os << "Antena at " << a.pos << " " << a.frequency;
  return os;
}

bool in_bounds(Position const &p, number_t N, number_t M) {
  return 0 <= p.x && p.x < N && 0 <= p.y && p.y < M;
}

auto get_value(lines_t const &map, Position const &p) { return map[p.x][p.y]; }

auto get_antenas(lines_t const &lines) {
  std::vector<Antena> antenas;
  number_t N = lines.size();
  number_t M = lines[0].size();
  for (number_t i = 0; i < N; i++) {
    for (number_t j = 0; j < M; j++) {
      if (lines[i][j] != EMPTY) {
        antenas.push_back({{i, j}, lines[i][j]});
      }
    }
  }
  return antenas;
}

number_t part1(lines_t &lines) {
  std::set<Position> antinodes;
  number_t N = lines.size();
  number_t M = lines[0].size();
  auto antenas = get_antenas(lines);
  for (auto a1 = std::begin(antenas); a1 != std::end(antenas); a1++) {
    for (auto a2 = std::next(a1); a2 != std::end(antenas); a2++) {
      if (a1->frequency == a2->frequency) {
        auto diff = a2->pos - a1->pos;
        auto option1 = a1->pos - diff;
        auto option2 = a2->pos + diff;
        if (in_bounds(option1, N, M)) {
          antinodes.emplace(option1);
        }
        if (in_bounds(option2, N, M)) {
          antinodes.emplace(option2);
        }
      }
    }
  }

  return antinodes.size();
}

number_t part2(lines_t &lines) {
  std::set<Position> antinodes;
  number_t N = lines.size();
  number_t M = lines[0].size();
  auto antenas = get_antenas(lines);
  for (auto a1 = std::begin(antenas); a1 != std::end(antenas); a1++) {
    for (auto a2 = std::next(a1); a2 != std::end(antenas); a2++) {
      if (a1->frequency == a2->frequency) {
        auto diff = a2->pos - a1->pos;
        auto option1 = a1->pos;
        while (in_bounds(option1, N, M)) {
          antinodes.emplace(option1);
          option1 = option1 - diff;
        }
        auto option2 = a2->pos;
        while (in_bounds(option2, N, M)) {
          antinodes.emplace(option2);
          option2 = option2 + diff;
        }
      }
    }
  }

  return antinodes.size();
}

int main(int argc, char *argv[]) {

  std::string file_path = "inputs/day8/test.txt";
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
