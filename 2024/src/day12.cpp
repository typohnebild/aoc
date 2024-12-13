#include "../include/util.hpp"

#include <algorithm>
#include <cassert>
#include <functional>
#include <iomanip>
#include <iostream>
#include <numeric>
#include <ranges>
#include <set>
#include <string>
#include <vector>

namespace rng = std::ranges;
namespace rv = std::ranges::views;
using number_t = int64_t;
using vec_t = std::vector<number_t>;
using lines_t = std::vector<std::string>;
using pos_t = std::pair<number_t, number_t>;

struct Grid {
  Grid(std::vector<std::string> const &data)
      : data_(data), N(data.size()), M(data[0].size()) {}

  bool in_bounds(number_t i, number_t j) {
    return 0 <= i && i < N && 0 <= j && j < M;
  }
  bool in_bounds(pos_t const &pos) { return in_bounds(pos.first, pos.second); }
  char get(int64_t i, int64_t j) { return data_[i][j]; }
  char get(pos_t pos) { return get(pos.first, pos.second); }
  void set(int64_t i, int64_t j, char value) { data_[i][j] = value; }
  void print() {
    for (auto &l : data_) {
      std::print("{}\n", l);
    }
    std::print("\n");
  }
  bool same(pos_t const &lhs, pos_t const &rhs) { return get(lhs) == get(rhs); }
  bool not_same(pos_t &cur, pos_t const &rhs) {
    // assumes that cur is valid position
    assert(in_bounds(cur));
    if (!in_bounds(rhs)) {
      return true;
    }
    return get(cur) != get(rhs);
  }

  std::vector<std::string> data_;
  number_t N;
  number_t M;
};

const std::vector<pos_t> dirs = {
    {0, 1},
    {1, 0},
    {0, -1},
    {-1, 0},
};

pos_t operator+(pos_t const &lhs, pos_t const &rhs) {
  return {lhs.first + rhs.first, lhs.second + rhs.second};
}

pos_t operator-(pos_t const &lhs, pos_t const &rhs) {
  return {lhs.first - rhs.first, lhs.second - rhs.second};
}

number_t part1(lines_t const &lines) {
  Grid grid(lines);
  grid.print();
  std::vector<std::vector<bool>> visited;
  for (number_t j = 0; j < grid.N; j++) {
    visited.push_back(std::vector<bool>(grid.M, false));
  }
  number_t ret = 0;
  for (number_t i = 0; i < grid.N; i++) {
    for (number_t j = 0; j < grid.M; j++) {
      if (visited[i][j]) {
        continue;
      }
      std::vector<pos_t> stack;
      stack.push_back({i, j});
      // char cur_plant = grid.get(i, j);
      number_t area = 0;
      number_t perimeter = 0;
      while (!stack.empty()) {
        auto cur = stack.back();
        stack.pop_back();
        area++;
        visited[cur.first][cur.second] = true;
        for (auto const &dir : dirs) {
          auto new_pos = cur + dir;
          if (grid.in_bounds(new_pos) && grid.same(cur, new_pos)) {
            if (!visited[new_pos.first][new_pos.second] &&
                !rng::contains(stack, new_pos)) {
              stack.push_back(new_pos);
            }
          } else {
            perimeter++;
          }
        }

        // std::print("{} {}: area: {} perimeter:{}\n", cur, cur_plant, area,
        //            perimeter);
      }
      ret += (perimeter * area);
    }
  }
  return ret;
}

number_t diff(pos_t const &lhs, pos_t const &rhs) {
  return std::abs(lhs.first - rhs.first) + std::abs(lhs.second - rhs.second);
}

number_t part2(lines_t const &lines) {
  Grid grid(lines);
  // grid.print();
  std::vector<std::vector<bool>> visited;
  for (number_t j = 0; j < grid.N; j++) {
    visited.push_back(std::vector<bool>(grid.M, false));
  }
  struct Region {
    char plant;
    number_t area{0};
    std::vector<pos_t> fields;
  };
  std::vector<Region> regions;
  number_t ret = 0;
  for (number_t i = 0; i < grid.N; i++) {
    for (number_t j = 0; j < grid.M; j++) {
      if (visited[i][j]) {
        continue;
      }
      std::vector<pos_t> stack;
      stack.push_back({i, j});
      char cur_plant = grid.get(i, j);
      Region r{cur_plant, 0, std::vector<pos_t>()};
      while (!stack.empty()) {
        auto cur = stack.back();
        stack.pop_back();
        visited[cur.first][cur.second] = true;
        r.area++;
        r.fields.push_back(cur);
        for (auto const &dir : dirs) {
          auto new_pos = cur + dir;
          if (grid.in_bounds(new_pos) && grid.same(cur, new_pos)) {
            if (!visited[new_pos.first][new_pos.second] &&
                !rng::contains(stack, new_pos)) {
              stack.push_back(new_pos);
            }
          }
        }
      }
      regions.push_back(r);
    }
  }

  constexpr pos_t diag[4] = {
      {1, 1},
      {1, -1},
      {-1, 1},
      {-1, -1},

  };
  for (auto &r : regions) {

    number_t sides = 0;
    for (auto &cur : r.fields) {
      for (auto const &dir : diag) {
        auto d = cur + dir;
        auto n1 = cur + pos_t(dir.first, 0);
        auto n2 = cur + pos_t(0, dir.second);
        if (!rng::contains(r.fields, d)) {
          if ((grid.not_same(cur, n1) && grid.not_same(cur, n2)) ||
              (!grid.not_same(cur, n1) && !grid.not_same(cur, n2))) {
            sides++;
          }
        } else {
          if (grid.not_same(cur, n1) && grid.not_same(cur, n2)) {
            sides++;
          }
        }
      }
    }
    ret += (r.area * sides);
  }
  return ret;
}

int main(int argc, char *argv[]) {

  std::string file_path = "inputs/day12/test.txt";
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
