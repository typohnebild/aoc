import std.stdio;
import std.array;
import std.algorithm;
import std.conv;
import std.range;
import std.string;
import std.file;
import std.exception : enforce;
import std.format;
import util : print_result;

int[] parse(string content)
{
    return content.splitter
        .map!strip
        .map!(to!int)
        .array;
}

int[] read()
{
    return "input".readText.parse;
}

void find_pair(int[] list, out int lhs, out int rhs)
{

    foreach (cur; list)
    {
        int target = 2020 - cur;
        if (target < 1)
        {
            continue;
        }
        auto ptr = list.find(target);
        if (!ptr.empty)
        {
            lhs = cur;
            rhs = ptr.front;
            return;
        }

    }
    enforce(true, "Did not find a pair that sums up to 2020");
}

void find_triple(int[] list, out int x_1, out int x_2, out int x_3)
{

    foreach (cur_1; list)
    {
        foreach (cur_2; list)
        {
            int target = 2020 - cur_1 - cur_2;
            if (target < 1)
            {
                continue;
            }
            auto ptr = list.find(target);
            if (!ptr.empty)
            {
                x_1 = cur_1;
                x_2 = cur_2;
                x_3 = ptr.front;
                return;
            }
        }
    }
    enforce(true, "Did not find a triple that sums up to 2020");
}

int solve(out int lhs, out int rhs)
{
    auto list = read();
    find_pair(list, lhs, rhs);
    return lhs * rhs;
}

int solve2(out int x1, out int x2, out int x3)
{
    auto list = read();
    find_triple(list, x1, x2, x3);
    return x1 * x2 * x3;
}

void day1()
{
    int lhs, rhs;
    int solution = solve(lhs, rhs);
    int x1, x2, x3;
    int solution2 = solve2(x1, x2, x3);
    print_result(1, solution, solution2);
}

unittest
{
    auto list = read();
    int lhs, rhs;
    find_pair(list, lhs, rhs);
    assert(lhs + rhs == 2020);
    int x1, x2, x3;
    find_triple(list, x1, x2, x3);
    assert(x1 + x2 + x3 == 2020);
}
