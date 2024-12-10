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
using number_t = int;
using vec_t = std::vector<number_t>;
using lines_t = std::vector<std::string>;
using map_t = std::vector<std::vector<number_t>>;
using pos_t = std::pair<number_t, number_t>;

const std::vector<pos_t> dirs = {
    {0, 1},
    {0, -1},
    {1, 0},
    {-1, 0},
};

auto split_to_ints(std::string_view line) {
  return line |
         rv::transform([](auto &&c) { return std::stoi(std::string{c}); }) |
         rng::to<std::vector<number_t>>();
}

map_t get_map(lines_t const &lines) {
  return lines | rv::transform(split_to_ints) | rng::to<std::vector>();
}

void print_map(map_t const &map) {
  for (auto &l : map) {
    for (auto &c : l) {
      std::cout << c;
    }
    std::cout << "\n";
  }
  std::cout << "\n";
}

pos_t operator+(pos_t const &lhs, pos_t const &rhs) {
  return {lhs.first + rhs.first, lhs.second + rhs.second};
}

auto get_value(map_t const &map, pos_t pos) {
  return map[pos.first][pos.second];
}

template <typename T> void set_value(map_t &map, pos_t pos, T value) {
  map[pos.first][pos.second] = value;
}
number_t get_score(map_t const &map, pos_t pos,
                   std::vector<pos_t> const &nines) {

  number_t N = map.size();
  number_t M = map[0].size();

  std::vector<std::vector<bool>> visited;
  map_t dist;
  std::vector<pos_t> q;

  for (number_t i = 0; i < N; i++) {
    dist.push_back(vec_t(M));
    visited.push_back(std::vector<bool>(M));
    for (number_t j = 0; j < M; j++) {
      dist[i][j] = std::numeric_limits<number_t>::max();
      visited[i][j] = false;
    }
  }
  q.push_back(pos);
  // dist[zeros[0].first][zeros[0].second] = 0;
  set_value(dist, pos, 0);
  // print_map(dist);
  while (!q.empty()) {
    // std::print("{}\n", q);
    pos_t cur = q[0];
    q.erase(q.begin());
    if (visited[cur.first][cur.second]) {
      continue;
    }
    for (auto &dir : dirs) {
      auto new_pos = cur + dir;
      if (0 <= new_pos.first && new_pos.first < N && 0 <= new_pos.second &&
          new_pos.second < M &&
          get_value(map, new_pos) == get_value(map, cur) + 1) {
        if (get_value(dist, new_pos) > get_value(dist, cur) + 1) {
          set_value(dist, new_pos, get_value(dist, cur) + 1);
          q.push_back(new_pos);
        }
      }
    }
  }
  number_t ret = 0;
  for (auto &nine : nines) {
    if (get_value(dist, nine) == 9) {
      ret++;
    }
  }
  return ret;
}

void DFS(map_t const &map, std::vector<pos_t> cur_path, pos_t cur, pos_t stop,
         std::vector<std::vector<bool>> &visited,
         std::vector<std::vector<pos_t>> &all_paths) {
  if (visited[cur.first][cur.second]) {
    return;
  }

  visited[cur.first][cur.second] = true;
  cur_path.push_back(cur);
  if (cur == stop) {
    all_paths.push_back(cur_path);
    cur_path.pop_back();
    visited[cur.first][cur.second] = false;
  }

  number_t N = map.size();
  number_t M = map[0].size();
  for (auto &dir : dirs) {
    auto new_pos = cur + dir;
    if (0 <= new_pos.first && new_pos.first < N && 0 <= new_pos.second &&
        new_pos.second < M &&
        get_value(map, new_pos) == get_value(map, cur) + 1) {
      DFS(map, cur_path, new_pos, stop, visited, all_paths);
    }
  }
  cur_path.pop_back();
  visited[cur.first][cur.second] = false;
}

number_t count_all_paths(map_t const &map, pos_t start, pos_t stop) {

  number_t N = map.size();
  number_t M = map[0].size();

  std::vector<std::vector<bool>> visited;
  std::vector<pos_t> cur_path;
  std::vector<std::vector<pos_t>> all_paths;

  for (number_t i = 0; i < N; i++) {
    visited.push_back(std::vector<bool>(M));
    for (number_t j = 0; j < M; j++) {
      visited[i][j] = false;
    }
  }
  DFS(map, cur_path, start, stop, visited, all_paths);
  return all_paths.size();
}

number_t part1(lines_t &lines) {
  auto map = get_map(lines);
  // print_map(map);
  std::vector<pos_t> zeros;
  std::vector<pos_t> nines;
  number_t N = map.size();
  number_t M = map[0].size();
  for (number_t i = 0; i < N; i++) {
    for (number_t j = 0; j < M; j++) {
      if (map[i][j] == 0) {
        zeros.push_back({i, j});
      }
      if (map[i][j] == 9) {
        nines.push_back({i, j});
      }
    }
  }
  number_t ret = 0;
  for (auto &zero : zeros) {
    ret += get_score(map, zero, nines);
  }

  return ret;
}

number_t part2(lines_t &lines) {
  auto map = get_map(lines);
  // print_map(map);
  std::vector<pos_t> zeros;
  std::vector<pos_t> nines;
  number_t N = map.size();
  number_t M = map[0].size();
  for (number_t i = 0; i < N; i++) {
    for (number_t j = 0; j < M; j++) {
      if (map[i][j] == 0) {
        zeros.push_back({i, j});
      }
      if (map[i][j] == 9) {
        nines.push_back({i, j});
      }
    }
  }
  number_t ret = 0;
  for (auto &zero : zeros) {
    for (auto &nine : nines) {
      ret += count_all_paths(map, zero, nine);
    }
  }

  return ret;
}

int main(int argc, char *argv[]) {

  std::string file_path = "inputs/day10/test.txt";
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
