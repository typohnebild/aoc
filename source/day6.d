import std.stdio;
import std.file;
import std.algorithm;
import std.array;
import std.string;
import std.conv;
import std.format;
import std.range;

auto parseGroups(string input = "input.txt")
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

auto solve(string input = "input.txt")
{
    return input.parseGroups
        .map!(x => x.splitter.join.array.sort.uniq.count)
        .sum;
}

auto solve2(string input = "input.txt")
{
    return input.parseGroups
        .map!(x => x.splitter.array.intersection)
        .map!count
        .sum;
}

auto solve_from_internet(string input = "input.txt")
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

void main()
{
    // solution stole
    stdin.byLine()
        .map!(to!string)
        .array.splitter([])
        .map!(
                a => a.join.array
                .sort.group
                .filter!(b => b[1] == a.length)
                .walkLength)
        .sum.writeln;
}

unittest
{
    solve.writeln;
    solve2.writeln;
    solve_from_internet.writeln;
    assert("mws" == ["kimczeyaqwbs", "pwmsf", "wgmfus", "lofjwnms", "rwsum"].intersection);
}
