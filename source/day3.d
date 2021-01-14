import std.stdio;
import std.file;
import std.array;
import std.algorithm;
import std.range;
import std.string;
import util;

string[] read_field(string input = defaultinput!3)
{
    return input.readText.splitter.map!strip.array;

}

size_t count_trees(char target = '#')(string[] field, size_t slope_x = 1, size_t slope_y = 3)
{
    size_t h = field.length / slope_x;
    size_t w = field[0].length;
    return iota(0, h).count!(x => field[x * slope_x][(x * slope_y) % w] == target);
}

void day3()
{
    auto field = read_field();
    size_t h = field.length;
    auto trees = field.count_trees;
    auto free = field.count_trees!('.');
    assert(h == trees + free);
    auto slopes = [[1, 1], [1, 3], [1, 5], [1, 7], [2, 1]];
    auto solution = slopes.map!(x => field.count_trees(x[0], x[1]));
    auto solution2 = solution.reduce!"a*b";
    print_result(3, trees, solution2);
}
