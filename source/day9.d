module day9;
import util;

import std.stdio;
import std.file : readText;
import std.conv : to;
import std.algorithm;
import std.format;
import std.array;
import std.range;

long[] parse_numbers(in string input = defaultinput!9)
{
    return input.readText.splitter.map!(to!long).array;
}

bool isValid(long[] preamble, long number)
{
    return cartesianProduct(preamble, preamble).canFind!(x => x[0] + x[1] == number);
}

long solve(long[] numbers, long preamble_size = 25)
{
    auto idx = iota(preamble_size, numbers.length).find!(
            i => !isValid(
            numbers[i - preamble_size .. i], numbers[i])).front;

    // format!"%d at position %d is not valid for %s"(numbers[idx], idx, numbers[idx - preamble_size .. idx])
    //     .writeln;

    return numbers[idx];
}

long[] find_range(long[] numbers, long number)
{
    size_t lower = 0;
    size_t upper = 1;
    while (true)
    {
        auto cur = numbers[lower .. upper].sum;
        if (cur < number)
        {
            upper++;
        }
        else if (cur > number)
        {
            lower++;

        }
        else
        {
            break;
        }
    }
    return numbers[lower .. upper];
}

long solve2(long[] numbers, long target)
{
    auto r = numbers.find_range(target);
    return r.minElement + r.maxElement;
}

void day9()
{
    auto numbers = defaultinput!9.parse_numbers;
    auto solution1 = numbers.solve;
    auto solution2 = numbers.solve2(solution1);
    print_result(9, solution1, solution2);
}

unittest
{
    long[] numbers = [35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576];
    assert(numbers.solve(5) == 127);
    assert(numbers.find_range(127) == [15, 25, 47, 40]);

}
