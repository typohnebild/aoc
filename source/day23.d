module day23;

import util;
import std.conv : to;
import std.algorithm : canFind, find, map, countUntil, remove, among;
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
    // an nice stolen solution from github
    // https://github.com/ephemient/aoc2020/blob/main/py/src/aoc2020/day23.py
    // the idea is storing the following number at the index of the cup
    auto nums = input.parse;
    auto arr = iota(1, 1_000_001).array;
    foreach (idx, value; nums.enumerate)
    {
        arr[value - 1] = idx + 1 < nums.length ? nums[idx + 1] - 1 : 9;
    }
    arr[$ - 1] = nums[0] - 1;
    int x = nums[0] - 1;
    int step(int cur)
    {
        auto fst = arr[cur];
        auto snd = arr[fst];
        auto thr = arr[snd];
        auto nxt = arr[thr];
        auto dst = cur;
        for (;;)
        {
            dst = dst > 0 ? dst - 1 : cast(int) arr.length - 1;
            if (!dst.among(fst, snd, thr))
            {
                break;
            }
        }
        arr[thr] = arr[dst];
        arr[cur] = nxt;
        arr[dst] = fst;
        return nxt;
    }

    foreach (_; 0 .. 10_000_000)
    {
        x = step(x);
    }

    auto fst = arr[0];
    auto snd = arr[fst];

    return (1L + fst) * (1L + snd);
}

void day23()
{
    auto solution1 = solve1("326519478");
    auto solution2 = solve2("326519478");
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
    assert(teststring.solve2 == 149_245_887_792);

}
