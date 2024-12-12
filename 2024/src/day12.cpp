#include "../include/util.hpp"

#include <algorithm>
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

number_t part2(lines_t const &lines) {
  Grid grid(lines);
  // grid.print();
  std::vector<std::vector<bool>> visited;
  for (number_t j = 0; j < grid.N; j++) {
    visited.push_back(std::vector<bool>(grid.M, false));
  }
  // struct res{
  //   number_t area{0};
  //   std::vector<number_t> horizontal;
  //   std::vector<number_t> vertical;
  //
  // };
  number_t ret = 0;
  for (number_t i = 0; i < grid.N; i++) {
    for (number_t j = 0; j < grid.M; j++) {
      if (visited[i][j]) {
        continue;
      }
      std::vector<pos_t> stack;
      stack.push_back({i, j});
      char cur_plant = grid.get(i, j);
      number_t area = 0;
      number_t perimeter = 0;
      std::vector<pos_t> vertical;
      std::vector<pos_t> horizontal;
      while (!stack.empty()) {
        auto cur = stack.back();
        stack.pop_back();
        area++;
        visited[cur.first][cur.second] = true;
        auto search_dirs =
            (i != 0 && j != 0) ? rv::take(dirs, 2) : rv::take(dirs, 4);
        for (auto const &dir : search_dirs) {
          auto new_pos = cur + dir;
          if (grid.in_bounds(new_pos) && grid.same(cur, new_pos)) {
            if (!visited[new_pos.first][new_pos.second] &&
                !rng::contains(stack, new_pos)) {
              stack.push_back(new_pos);
            }
          } else {
            if (dir.first != 0) {
              vertical.emplace_back(new_pos);
            } else {
              horizontal.emplace_back(new_pos);
            }
          }
        }
      }
      // perimeter = i_sides.size() + j_sides.size();
      // auto vs = vertical | rng::to<std::vector>();
      // auto hv = horizontal | rng::to<std::vector>();
      rng::sort(vertical);
      // rng::sort(horizontal);
      // std::print("{} {}", vertical, horizontal);
      auto c = vertical | rv::chunk_by([](auto &&a1, auto &&a2) {
                 return a1.first == a2.first;
               });
      std::print("vertical\n");
      for (auto &&line : c) {
        auto cs = line | rv::chunk_by([](auto &&a1, auto &&a2) {
                    return a1.second + 1 == a2.second;
                  }) |
                  rng::to<std::vector>();
        std::print("{}: {}\n", cur_plant, cs);
        perimeter += cs.size();
      }
      rng::sort(horizontal, [](auto &&a1, auto &&a2) {
        return a1.second < a2.second ||
               (a1.second == a2.second && a1.first < a2.first);
      });
      auto h = horizontal | rv::chunk_by([](auto &&a1, auto &&a2) {
                 return a1.second == a2.second;
               });

      std::print("horizontal\n");
      for (auto &&line : h) {
        auto cs = line | rv::chunk_by([](auto &&a1, auto &&a2) {
                    return a1.first + 1 == a2.first;
                  }) |
                  rng::to<std::vector>();
        std::print("{}\n", cs);
        perimeter += cs.size();
      }
      // std::print("{}\n", c);

      std::print("{} {}: area: {} perimeter:{}\n", pos_t{i, j}, cur_plant, area,
                 perimeter);
      ret += (perimeter * area);
    }
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
