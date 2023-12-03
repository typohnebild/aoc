#pragma once

#include <fstream>
#include <string>
#include <vector>

bool read_as_list_of_strings(std::string filename,
                             std::vector<std::string> &lines);
