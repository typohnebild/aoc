#include "../include/util.hpp"
#include <cstdlib>
#include <fstream>
#include <iostream>

bool read_as_list_of_strings(std::string filename,
                             std::vector<std::string> &lines) {
  std::ifstream infile(filename);
  if (!infile) {
    std::cerr << "*****Error opening file " << filename << std::endl;
    return false;
  }
  std::string line;
  while (getline(infile, line)) {
#ifdef DEBUG_RUNNER
    cout << "Read line [" << line << "] from file" << endl;
#endif
    lines.push_back(line);
  }
  infile.close();
  return true;
}
