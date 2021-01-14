import std;

size_t next(size_t[] seq)
{
    auto x = seq[0 .. $ - 1].retro.countUntil(seq.back);
    if (x == -1)
    {
        return 0;
    }
    else
    {
        return seq.length - (seq.length - 1U - x);
    }

}

size_t solve(size_t[] start, size_t stop_t)
{
    while (start.length < stop_t)
    {
        start ~= next(start);
    }
    return start.back;
}

size_t solve2(size_t[] start, size_t stop_t)
{
    size_t[][size_t] dict;
    start.enumerate.each!(x => dict[x[1]] = [x[0] + 1]);
    size_t t = start.length;
    size_t last = start.back;
    while (t < stop_t)
    {
        size_t next;
        auto ptr = dict[last];
        if (ptr.length >= 2)
        {
            next = ptr.back - ptr[$ - 2];
        }
        else
        {
            next = 0;
        }
        t++;
        dict[next] ~= t;
        last = next;
    }

    return last;
}

void main()
{
    [12, 1, 16, 3, 11, 0].solve2(2020).writeln;
    [12, 1, 16, 3, 11, 0].solve2(30_000_000).writeln;
}

unittest
{
    assert(solve([0, 3, 6], 10) == 0);
    assert(solve([1, 3, 2], 2020) == 1);

    assert(solve([2, 1, 3], 2020) == 10);
    assert(solve([1, 2, 3], 2020) == 27);
    assert(solve([2, 3, 1], 2020) == 78);
    assert(solve([3, 2, 1], 2020) == 438);
    assert(solve([3, 1, 2], 2020) == 1836);

    assert(solve2([0, 3, 6], 10) == 0);
    assert(solve2([1, 3, 2], 2020) == 1);
    assert(solve2([2, 1, 3], 2020) == 10);
    assert(solve2([1, 2, 3], 2020) == 27);
    assert(solve2([2, 3, 1], 2020) == 78);
    assert(solve2([3, 2, 1], 2020) == 438);
    assert(solve2([3, 1, 2], 2020) == 1836);

}
