#include "../include/util.hpp"

#include <algorithm>
#include <iostream>
#include <ranges>
#include <set>
#include <string>
#include <unordered_set>
#include <vector>

namespace rng = std::ranges;
namespace rv = std::ranges::views;
using number_t = int;
using vec_t = std::vector<number_t>;
using lines_t = std::vector<std::string>;
using pos_t = std::pair<number_t, number_t>;
constexpr char up = '^';
constexpr char right = '>';
constexpr char down = 'v';
constexpr char left = '<';
constexpr char dir_chars[4] = {up, right, down, left};

constexpr std::pair<number_t, number_t> dirs[4] = {
    {-1, 0}, {0, 1}, {1, 0}, {0, -1}};

bool is_loop(lines_t &lines) {
  number_t cur_x = 0;
  number_t cur_y = 0;
  char cur_dir = up;
  number_t N = lines.size();
  number_t M = lines[0].size();
  std::vector<std::vector<number_t>> visited;
  for (number_t i = 0; i < N; i++) {
    visited.push_back(std::vector<number_t>(M, 0));
    for (number_t j = 0; j < M; j++) {
      if (lines[i][j] == up || lines[i][j] == down || lines[i][j] == right ||
          lines[i][j] == left) {
        cur_x = i;
        cur_y = j;
        cur_dir = lines[i][j];
      }
    }
  }
  auto is_obstical = [&](number_t x, number_t y) { return lines[x][y] == '#'; };
  std::vector<pos_t> trace;
  while (cur_x >= 0 && cur_x < N && cur_y >= 0 && cur_y < M) {
    if (visited[cur_x][cur_y] > 2) {
      auto cur_pos = std::make_pair(cur_x, cur_y);
      auto first_round = rv::reverse(trace) |
                         rv::drop_while([&](auto &&c) { return c != cur_pos; });
      auto second_round = rv::reverse(trace) | rv::take_while([&](auto &&s) {
                            return s != cur_pos;
                          });
      for (auto [first, second] : rv::zip(first_round, second_round)) {
        if (first != second) {
          if (first == cur_pos) {
            return true;
          }
          break;
        }
      }
    }
    trace.push_back({cur_x, cur_y});
    visited[cur_x][cur_y]++;
    for (number_t i = 0; i < 4; i++) {
      if (cur_dir == dir_chars[i]) {
        if (is_obstical(cur_x + dirs[i].first, cur_y + dirs[i].second)) {
          cur_dir = dir_chars[(i + 1) % 4];
          break;
        }
      }
    }
    for (number_t i = 0; i < 4; i++) {
      if (cur_dir == dir_chars[i]) {
        cur_x += dirs[i].first;
        cur_y += dirs[i].second;
      }
    }
    // std::cout << cur_x << ", " << cur_y << std::endl;
  }

  return false;
}

number_t part2(lines_t &lines, std::vector<pos_t> &trace) {
  std::set<std::pair<number_t, number_t>> new_obstacles;
  auto is_obstical = [&](number_t x, number_t y) { return lines[x][y] == '#'; };
  auto is_valid = [&](std::pair<number_t, number_t> &p) {
    auto [x, y] = p;
    return x >= 0 && y >= 0 && x < number_t(lines.size()) &&
           y < number_t(lines[0].size());
  };
  for (auto &step : trace) {
    for (number_t d = 0; d < 4; d++) {
      pos_t possible_pos{step.first + dirs[d].first,
                         step.second + dirs[d].second};

      if (is_valid(possible_pos) &&
          !is_obstical(possible_pos.first, possible_pos.second)) {
        auto prev_state = lines[possible_pos.first][possible_pos.second];
        lines[possible_pos.first][possible_pos.second] = '#';
        if (is_loop(lines)) {
          new_obstacles.emplace(possible_pos);
        }
        lines[possible_pos.first][possible_pos.second] = prev_state;
      }
    }
  }
  std::print("{}\n", new_obstacles);

  return new_obstacles.size();
}

number_t part1(lines_t &lines, std::vector<pos_t> &trace) {
  number_t ret = 0;
  number_t cur_x = 0;
  number_t cur_y = 0;
  char cur_dir = up;
  number_t N = lines.size();
  number_t M = lines[0].size();
  std::vector<std::vector<bool>> visited;
  for (number_t i = 0; i < N; i++) {
    visited.push_back(std::vector<bool>(M, false));
    for (number_t j = 0; j < M; j++) {
      if (lines[i][j] == up || lines[i][j] == down || lines[i][j] == right ||
          lines[i][j] == left) {
        cur_x = i;
        cur_y = j;
        cur_dir = lines[i][j];
      }
    }
  }
  auto is_obstical = [&](number_t x, number_t y) { return lines[x][y] == '#'; };
  while (cur_x >= 0 && cur_x < N && cur_y >= 0 && cur_y < M) {
    trace.push_back({cur_x, cur_y});
    if (!visited[cur_x][cur_y]) {
      ret++;
    }
    visited[cur_x][cur_y] = true;
    for (number_t i = 0; i < 4; i++) {
      if (cur_dir == dir_chars[i]) {
        if (is_obstical(cur_x + dirs[i].first, cur_y + dirs[i].second)) {
          cur_dir = dir_chars[(i + 1) % 4];
          break;
        }
      }
    }
    for (number_t i = 0; i < 4; i++) {
      if (cur_dir == dir_chars[i]) {
        cur_x += dirs[i].first;
        cur_y += dirs[i].second;
      }
    }
    // std::cout << cur_x << ", " << cur_y << std::endl;
  }

  return ret;
}

int main(int argc, char *argv[]) {

  std::string file_path = "inputs/day6/test.txt";
  if (argc == 2) {
    file_path = argv[1];
  }
  {
    lines_t lines;
    read_as_list_of_strings(file_path, lines);
    std::vector<pos_t> trace;
    auto res = part1(lines, trace);
    std::cout << "Part 1: " << res << std::endl;
    auto res2 = part2(lines, trace);
    std::cout << "Part 2: " << res2 << std::endl;
  }

  return 0;
}
