module day6;

import std.stdio;
import std.file;
import std.algorithm;
import std.array;
import std.string;
import std.conv;
import std.format;
import std.range;
import util;

auto parseGroups(string input = defaultinput!6)
{
    return input.readText.splitter("\n\n");
}

T intersection(T)(T[] args)
{
    if (args.empty)
    {
        return "";
    }
    auto ret = args.front.dup;
    args[1 .. $].each!(item => ret = ret.remove!(x => item.all!(c => c != x)));
    return ret.to!T;
}

auto solve(string input = defaultinput!6)
{
    return input.parseGroups
        .map!(x => x.splitter.join.array.sort.uniq.count)
        .sum;
}

auto solve2(string input = defaultinput!6)
{
    return input.parseGroups
        .map!(x => x.splitter.array.intersection)
        .map!count
        .sum;
}

auto solve_from_internet(string input = defaultinput!6)
{
    return File(input).byLine()
        .map!(to!string)
        .array.splitter([])
        .map!(
                a => a.join.array
                .sort.group
                .filter!(b => b[1] == a.length)
                .walkLength)
        .sum;
}

void day6()
{
    print_result(6, solve, solve2);
}
