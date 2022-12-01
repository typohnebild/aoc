module day10;
import util;

import std;

long[] read_input(in string input = defaultinput!10)
{
    return File(input).byLine().map!(to!long).array;
}

long solve(long[] numbers)
{
    auto distances = chain([0L], numbers.sort, [numbers.maxElement + 3]).slide(2)
        .map!"a[1] - a[0]";

    return distances.count!"a == 1" * distances.count!"a == 3";
}

auto solve2(long[] numbers)
{
    auto all = chain(numbers.sort, [numbers.maxElement + 3]);
    auto optional = all.setDifference(all.slide(2)
            .filter!"a[1] - a[0] == 3".joiner).array;
    size_t i = 0;
    long options = 1;
    while (i < optional.length)
    {
        auto cur_seq = 1;
        while (i < optional.length - 1U && optional[i + 1] - optional[i] == 1)
        {
            cur_seq++;
            i++;
        }
        // format!"cur_seq: %d"(cur_seq).writeln;
        if (cur_seq == 1)
        {
            options *= 2;
        }
        else if (cur_seq == 2)
        {
            options *= 4;
        }
        else if (cur_seq == 3)
        {
            options *= 7;
        }
        i++;

    }
    return options;
}

void day10()
{
    print_result(10, read_input.solve, read_input.solve2);
}

unittest
{
    long[] example1 = [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4];
    long[] example2 = [28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19, 38, 39,
        11, 1, 32, 25, 35, 8, 17, 7, 9, 4, 2, 34, 10, 3];
    assert(example1.solve == 7 * 5);
    assert(example2.solve == 22 * 10);

    assert(example1.solve2 == 8);
    assert(example2.solve2 == 19_208);
}
