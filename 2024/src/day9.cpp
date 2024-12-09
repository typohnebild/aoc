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
using number_t = int64_t;
using vec_t = std::vector<number_t>;
using lines_t = std::vector<std::string>;
constexpr number_t FREE = -1;

void print_memory(std::vector<number_t> const &memory) {
  for (auto m : memory) {
    if (m == FREE) {
      std::cout << ".";
    } else {
      std::cout << m;
    }
  }
  std::cout << std::endl;
}

std::pair<number_t, vec_t> get_memory(lines_t const &lines) {

  bool file = true;
  number_t id = 0;
  std::vector<number_t> memory;
  number_t last_non_free = 0;
  for (auto &&line : lines) {
    // std::cout << line << std::endl;
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
  return {last_non_free, memory};
}

number_t get_checksum(std::vector<number_t> const &memory) {

  number_t ret = 0;
  std::vector<number_t> a;
  for (number_t i = 0; i < number_t(memory.size()); i++) {
    if (memory[i] != FREE) {
      ret += (i * memory[i]);
    }
  }
  return ret;
  // auto eval_checksum = [](auto &&p) {
  //   auto [idx, m] = p;
  //   if (m != FREE) {
  //     return idx * (m);
  //   }
  //   return number_t(0);
  // };
  //
  // return rng::fold_left(rv::zip(rv::iota(0), memory) |
  //                           rv::transform(eval_checksum),
  //                       number_t(0), std::plus{});
}

number_t part1(lines_t &lines) {
  auto [last_non_free, memory] = get_memory(lines);
  // print_memory(memory);

  for (number_t i = 0; i < number_t(memory.size()); i++) {
    if (i >= last_non_free) {
      break;
    }
    if (memory[i] == FREE) {
      memory[i] = memory[last_non_free];
      memory[last_non_free] = FREE;
      while (memory[last_non_free] == FREE) {
        last_non_free--;
      }
    }
  }
  return get_checksum(memory);
}

number_t part2(lines_t &lines) {
  auto [last_non_free, memory] = get_memory(lines);
  // print_memory(memory);

  for (number_t i = number_t(memory.size()) - 1; i > 0; i--) {
    if (memory[i] == FREE) {
      continue;
    }
    number_t offset = (memory.size() - i) - 1;
    auto file = rv::take_while(rv::reverse(memory) | rv::drop(offset),
                               [&](auto &&s) { return s == memory[i]; });

    auto size = rng::distance(rng::begin(file), rng::end(file));
    auto free_space = rng::search(memory, rv::repeat(FREE, size));
    auto free_space_size =
        rng::distance(rng::begin(free_space), rng::end(free_space));
    auto file_start = rng::distance(rng::begin(file), rng::rend(memory));
    auto free_space_start =
        rng::distance(rng::begin(memory), rng::begin(free_space));

    // std::print("{} {}: Found at {} {} -> {} {} size {} at {}\n", i, offset,
    //            file_start, file, free_space_start, free_space, size,
    //            memory[i]);
    if (free_space_size >= size && file_start > free_space_start) {
      for (auto &f : free_space) {
        // std::print("Swapping {} by {}\n", f, memory[i]);
        f = memory[i];
      }
      for (number_t k = 0; k < number_t(size); k++) {
        // std::print("Overwritting {} by {}\n", memory[i - k], FREE);
        memory[i - k] = FREE;
      }

      // print_memory(memory);
    }

    i -= (size - 1);
  }

  auto r = rv::zip(rv::iota(0), memory) | rv::transform([](auto &&p) {
             auto [idx, m] = p;
             if (m != FREE) {

               return idx * (m);
             }
             return number_t(0);
           });

  return rng::fold_left(r, number_t(0), std::plus{});
}

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
