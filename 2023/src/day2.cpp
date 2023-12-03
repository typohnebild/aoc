#include "../include/util.hpp"
#include <exception>
#include <iostream>
#include <ostream>
#include <regex>
#include <stdexcept>
#include <string>
#include <vector>

struct Game {
  int id;
  int blue{0};
  int red{0};
  int green{0};
};

std::ostream &operator<<(std::ostream &os, Game const &g) {
  os << "Game: " << g.id << " { blue=" << g.blue << ",red=" << g.red
     << ",green=" << g.green << "}";
  return os;
}

int extractID(std::string const &game) {
  std::regex pattern("Game ([0-9]+):.*");
  std::smatch match;
  if (std::regex_match(game, match, pattern)) {
    // std::cout << match[1].str() << std::endl;
    return std::stoi(match[1].str());
  }
  throw std::invalid_argument("Did not find an ID");
}
int get_color(std::string const &color, std::string const &game) {
  std::regex pattern("([0-9]+) " + color);
  int ret{0};
  auto begin = std::sregex_iterator(game.begin(), game.end(), pattern);
  auto end = std::sregex_iterator();
  for (auto i = begin; i != end; i++) {
    ret = std::max(ret, std::stoi((*i)[1]));
  }

  return ret;
}

Game parseGame(std::string const &game) {
  int id = extractID(game);
  int blue = get_color("blue", game);
  int red = get_color("red", game);
  int green = get_color("green", game);
  return Game{id, blue, red, green};
}
bool is_possible(Game const &max, Game const &game) {
  return game.blue <= max.blue && game.green <= max.green &&
         game.red <= max.red;
}

int part1(std::vector<std::string> const &lines) {
  Game target{0, 14, 12, 13};
  int ret{0};
  for (auto &line : lines) {
    auto game = parseGame(line);
    if (is_possible(target, game)) {
      ret += game.id;
    }
  }

  return ret;
}
int power(Game const &game) { return game.red * game.blue * game.green; }

int part2(std::vector<std::string> const &lines) {
  int ret{0};
  for (auto &line : lines) {
    auto game = parseGame(line);
    ret += power(game);
  }

  return ret;
}

int main() {
  {
    std::vector<std::string> lines;
    read_as_list_of_strings("inputs/day2/test_input1.txt", lines);
    std::cout << part1(lines) << std::endl;
    std::cout << part2(lines) << std::endl;
  }
  {
    std::vector<std::string> lines;
    read_as_list_of_strings("inputs/day2/input.txt", lines);
    std::cout << part1(lines) << std::endl;
    std::cout << part2(lines) << std::endl;
  }

  return 0;
}
