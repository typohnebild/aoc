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
using number_t = uint64_t;
using vec_t = std::vector<number_t>;
using lines_t = std::vector<std::string>;
constexpr number_t FREE = 0;

void print_memory(std::vector<number_t> const &memory) {
  for (auto m : memory) {
    if (m == FREE) {
      std::cout << ".";
    } else {
      std::cout << m - 1;
    }
  }
  std::cout << std::endl;
}

number_t part1(lines_t &lines) {
  bool file = true;
  number_t id = 1;
  std::vector<number_t> memory;
  number_t last_non_free = 0;
  for (auto &&line : lines) {
    std::cout << line << std::endl;
    for (char bl : line) {
      number_t size = std::stol(std::string{bl});
      if (file) {
        for (number_t i = 0; i < size; i++) {
          memory.push_back(id);
        }
        last_non_free = memory.size() - 1;
        ++id;
      } else {
        for (number_t i = 0; i < size; i++) {
          memory.push_back(FREE);
        }
      }
      file = !file;
    }
  }
  print_memory(memory);

  for (number_t i = 0; i < number_t(memory.size()); i++) {
    if (i >= last_non_free) {
      break;
    }
    if (memory[i] == FREE) {
      // std::print("swaping {} at {} with {} at {}\n", memory[i], i,
      //            memory[last_non_free], last_non_free);
      memory[i] = memory[last_non_free];
      memory[last_non_free] = FREE;
      while (memory[last_non_free] == FREE) {
        last_non_free--;
      }
      // print_memory(memory);
    }
  }

  print_memory(memory);
  // auto ret = 0;
  // for (number_t i = 0; i < number_t(memory.size()); i++) {
  //   if (memory[i] == FREE) {
  //     continue;
  //   }
  //   ret += (i * (memory[i] - 1));
  // }
  // return ret;
  auto r =
      rv::zip(rv::iota(0),
              memory | rv::take_while([](auto &&c) { return c != FREE; })) |
      rv::transform([](auto &&p) {
        auto [idx, m] = p;
      // std::print("{} {}\n", idx, m);
        return idx * (m - 1);
      });

  return rng::fold_left(r, number_t(0), std::plus{});
}

number_t part2(lines_t &lines) { return lines.size(); }

int main(int argc, char *argv[]) {

  std::string file_path = "inputs/day9/test.txt";
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
