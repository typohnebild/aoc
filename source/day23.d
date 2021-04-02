module day23;

import util;
import std.conv : to;
import std.algorithm : canFind, find, map, countUntil, remove;
import std.range;
import std.array;
import std.stdio;
import std.format;

struct Game(bool game2 = false)
{
    static pickupSize = 3;
    size_t steps;
    int[] cups;
    size_t curIdx;
    size_t len;
    int cur;
    this(in string input, size_t steps = 100)
    {
        this.cups = input.parse;
        static if (game2)
        {
            cups ~= iota(cups.length.to!int, 1_000_000 + 1).array;
        }
        this.curIdx = 0;
        this.len = cups.length;
        this.steps = steps + 1;
        this.cur = cups.front;
    }

    @property bool empty()
    {
        return steps == 0;
    }

    @property auto front() const
    {
        // return cups.cycle.find(1).take(len).map!(to!string).join("");
        return cups;
    }

    int nextLowerCup(int cup)
    {
        int ret = cup - 1;
        if (ret < 1)
        {
            return this.len.to!int;
        }
        return ret;
    }

    void popFront()
    {
        auto pickups = cups
            .cycle
            .find(cur)
            .dropOne
            .take(pickupSize)
            .array;

        auto dst = nextLowerCup(this.cur);
        while (pickups.canFind(dst))
        {
            dst = nextLowerCup(dst);
        }

        cups.remove!(x => pickups.canFind(x));
        cups.length = len - pickupSize;
        // format!"after remove %s"(cups).writeln;
        // format!"cur: %d dst: %d"(cur, dst).writeln;

        auto dstidx = cups.countUntil(dst);
        cups.insertInPlace(dstidx + 1, pickups);
        this.cur = cups
            .cycle
            .find(this.cur)
            .dropOne
            .front;
        this.steps--;

    }
}

string convert(in int[] cups)
{
    return cups
        .cycle
        .find(1)
        .take(cups.length)
        .dropOne
        .map!(to!string)
        .join("");
}

auto parse(in string input)
{
    return input.map!(c => c.to!int - '0').array;
}

immutable teststring = "389125467";

auto solve1(in string input)
{
    return Game!false(input).dropExactly(100).front.convert;
}

auto solve2(in string input)
{
    return Game!true(input)
        .dropExactly(10_000_000)
        .front;
}

void day23()
{
    auto solution1 = solve1("326519478");
    auto solution2 = "";
    print_result(23, solution1, solution2);
}

unittest
{
    auto g = Game!false(teststring, 10);
    g.popFront();
    assert(g.front == [3, 2, 8, 9, 1, 5, 4, 6, 7]);
    g.popFront();
    assert(g.front == [3, 2, 5, 4, 6, 7, 8, 9, 1]);
    auto stateafter10 = g.dropExactly(8).front;
    assert(stateafter10 == [5, 8, 3, 7, 4, 1, 9, 2, 6]);
    assert(stateafter10.convert == "92658374");
    assert(teststring.solve1 == "67384529");
    // solve2(teststring).writeln;
}
