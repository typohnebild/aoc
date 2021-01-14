module util;
import std.format : format;
import std.stdio : writeln;

auto defaultinput(int day) = format!"inputs/input%d"(day);

void print_result(T1, T2)(int day, T1 solution1, T2 solution2)
{
    format!"Solution for Day %d Part 1: %s Part2: %s"(day, solution1, solution2).writeln;
}
