module day5;
import util;

import std.stdio;
import std.file;
import std.range;
import std.array;
import std.string;
import std.algorithm;
import std.exception;
import std.string;
import std.format;

immutable ROWS = 128;
immutable COLUMNS = 8;

auto parse(string input = defaultinput!5)
{
    return input.readText.splitter.map!strip;

}

long calc_id(string line)
{
    long row = calculate!(ROWS)(line[0 .. 7]);
    long col = calculate!(COLUMNS)(line[7 .. 10]);
    // format!"row:%d col:%d"(row, col).writeln;
    return row * COLUMNS + col;
}

long calculate(long max)(in string code)
{
    long lower = 0;
    long upper = max - 1;
    long mid;
    foreach (x; code)
    {
        mid = (upper + lower) / 2;
        if (x == 'F' || x == 'L')
        {
            upper = mid;
        }
        else if (x == 'B' || x == 'R')
        {
            lower = mid + 1;
        }
        else
        {
            enforce(false, "Wrong char");
        }
    }
    assert(lower == upper);
    return lower;

}

auto ids()
{
    return parse.map!calc_id;
}

auto solve()
{
    return ids.reduce!((a, b) => max(a, b));
}

long solve2()
{
    auto all_ids = ids.array.sort;
    for (size_t i = 1; i < all_ids.length; i++)
    {
        if (all_ids[i] - all_ids[i - 1] != 1)
        {
            // all_ids[i - 2 .. i + 2].writeln;
            return all_ids[i] - 1;
        }
    }
    return all_ids[$ - 1] + 1;
}

void day5()
{
    print_result(5, solve, solve2);
}

unittest
{
    assert(calc_id("FBFBBFFRLR") == 357);
    assert(calc_id("BFFFBBFRRR") == 567);
    assert(calc_id("FFFBBBFRRR") == 119);
    assert(calc_id("BBFFBBFRLL") == 820);

}
