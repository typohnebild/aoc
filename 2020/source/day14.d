module day14;
import util;

import std;

struct MyInt
{
    BitArray _data;

    this(long n)
    {
        _data = BitArray([n], 36);
        apply_mask();
    }

    long to_long()
    {
        auto tmp = _data.dup;
        return tmp.reverse
            .format!"%b"
            .filter!(x => x != '_')
            .to!ulong(2);
    }

    void apply_mask()
    {
        if (mask.length > 0)
        {
            mask.each!(x => _data[x[0]] = x[1]);
        }
    }

    static Tuple!(ulong, bool)[] mask;
    static void setMask(in string m)
    {
        mask = m
            .enumerate
            .filter!(x => x[1] != 'X')
            .map!(x => tuple(m.length - 1U - x[0], x[1] == '1'))
            .array;
    }

}

auto generate_masks(in string mask, in long number)
{
    MyInt[] bits;
    bits ~= MyInt(number);
    foreach (index, item; mask.dup.reverse.enumerate)
    {
        if (item == '1')
        {
            bits.each!((ref x) => x._data[index] = 1);
        }
        else if (item == 'X')
        {
            auto new_bits = bits.map!(x => MyInt(x.to_long)).array;
            new_bits.each!((ref x) => x._data[index] = 0);
            bits.each!((ref x) => x._data[index] = 1);
            bits ~= new_bits;
        }
    }

    return bits.map!(x => x.to_long).array;
}

auto solve(in string input)
{
    MyInt[size_t] mem;

    auto handle = (string lhs, string rhs) {
        if (lhs == "mask")
        {
            MyInt.setMask(rhs);
        }
        else
        {
            size_t index;
            lhs.formattedRead!"mem[%d]"(index);
            mem[index] = MyInt(rhs.to!long);
        }
    };
    File(input).byLine()
        .map!(to!string)
        .map!strip
        .map!(x => x.split(" = "))
        .each!(x => handle(x[0], x[1]));
    return mem.byValue.map!(x => x.to_long).sum;
}

auto solve2(in string input)
{
    MyInt.setMask("");
    long[long] mem;
    string mask;
    auto handle = (string lhs, string rhs) {
        if (lhs == "mask")
        {
            mask = rhs;
        }
        else
        {
            long index;
            lhs.formattedRead!"mem[%d]"(index);
            long val = rhs.to!long;
            foreach (i; generate_masks(mask, index))
            {
                mem[i] = val;
            }
        }
    };
    File(input).byLine()
        .map!(to!string)
        .map!strip
        .map!(x => x.split(" = "))
        .each!(x => handle(x[0], x[1]));
    return mem.byValue.sum;
}

void day14()
{
    print_result(14, defaultinput!14.solve, defaultinput!14.solve2);
}

unittest
{
    string mask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X";
    MyInt.setMask(mask);
    assert(MyInt(11).to_long == 73);
    assert(MyInt(101).to_long == 101);
    assert(MyInt(0).to_long == 64);
}

unittest
{
    assert("inputs/input14_test".solve2 == 208);

}
