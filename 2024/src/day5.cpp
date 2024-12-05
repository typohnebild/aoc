#include "../include/util.hpp"

#include <algorithm>
#include <iostream>
#include <ranges>
#include <string>
#include <vector>

namespace rng = std::ranges;
namespace rv = std::ranges::views;
using number_t = int;
using vec_t = std::vector<number_t>;
using lines_t = std::vector<std::string>;

auto split_rules(std::string_view const &rule_string) {
  auto splitted = rule_string | rv::split('|') | rv::transform([](auto &&s) {
                    return std::stoi(rng::to<std::string>(s));
                  }) |
                  rng::to<std::vector>();
  return splitted;
}

auto split_updates(std::string_view const &update_string) {
  auto splitted = update_string | rv::split(',') | rv::transform([](auto &&s) {
                    return std::stoi(rng::to<std::string>(s));
                  }) |
                  rng::to<std::vector>();
  return splitted;
}

number_t part2(lines_t const &lines) {
  number_t ret = 0;
  auto rules = lines | rv::take_while([](auto &&s) { return s != ""; }) |
               rv::transform(split_rules) | rng::to<std::vector>();
  auto updates = lines | rv::drop_while([](auto &&s) { return s != ""; }) |
                 rv::drop(1) | rv::transform(split_updates) |
                 rng::to<std::vector>();

  auto find_break_rule = [&](auto l, auto r) {
    return rng::find_if(
        rules, [&](auto &&rule) { return rule[0] == r && rule[1] == l; });
  };
  auto correct = [&](auto &update) {
    number_t drops = 1;
    for (auto page : update) {
      for (auto other : update | rv::drop(drops)) {
        auto s = rng::find_if(rules, [&](auto &&rule) {
          return rule[0] == other && rule[1] == page;
        });
        if (s != rng::end(rules)) {
          return false;
        }
      }
      drops++;
    }
    return true;
  };
  for (auto &&c : updates | rv::filter([&](auto &&s) { return !correct(s); })) {
    std::vector<int> copy(c);
    for (int i = 0; i < int(c.size()); i++){
      for (int j = i; j < int(c.size()); j++){
        if (find_break_rule(copy[i], copy[j]) != rng::end(rules)){
          std::swap(copy[i], copy[j]);
        }
      }
    }
    std::print("{} ", copy);
    auto middle = copy[c.size() / 2];
    std::print("{}\n", middle);
    ret += middle;
  }

  return ret;
}

number_t part1(lines_t const &lines) {
  number_t ret = 0;
  auto rules = lines | rv::take_while([](auto &&s) { return s != ""; }) |
               rv::transform(split_rules) | rng::to<std::vector>();
  auto updates = lines | rv::drop_while([](auto &&s) { return s != ""; }) |
                 rv::drop(1) | rv::transform(split_updates) |
                 rng::to<std::vector>();

  auto correct = [&](auto &update) {
    number_t drops = 1;
    for (auto page : update) {
      for (auto other : update | rv::drop(drops)) {
        // std::print("{} {}", page, other);
        auto s = rng::find_if(rules, [&](auto &&rule) {
          return rule[0] == other && rule[1] == page;
        });
        if (s != rng::end(rules)) {
          return false;
        }
      }
      drops++;
    }
    return true;
  };
  for (auto &&c : updates | rv::filter(correct)) {
    auto middle = c[c.size() / 2];
    std::print("{} ", c);
    std::print("{}\n", middle);
    ret += middle;
  }

  return ret;
}

int main(int argc, char *argv[]) {

  std::string file_path = "inputs/day5/test.txt";
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
