module day8;
import util;

import std;

enum Ops : string
{
    jmp = "jmp",
    acc = "acc",
    nop = "nop",
    stop = "stop"

}

string[][] parser(in string input = defaultinput!8)
{
    return input.readText.splitter("\n").map!(x => x.splitter.array).array;
}

long solve(string input = defaultinput!8)
{
    auto code = input.parser;
    long acc = 0;
    simulate(code, acc);
    return acc;
}

bool simulate(string[][] code, out long acc)
{
    acc = 0;
    long cnt = 0;
    long old_cnt = 0;
    while (code[cnt].length != 0 && cnt < code.length)
    {
        // format!"cnt: %d, acc: %d op: %s"(cnt, acc, code[cnt]).writeln;
        old_cnt = cnt;
        switch (code[cnt][0])
        {
        case Ops.stop:
            return false;
        case Ops.jmp:
            cnt += code[cnt][1].to!long;
            break;
        case Ops.acc:
            acc += code[cnt][1].to!long;
            cnt++;
            break;
        case Ops.nop:
            cnt++;
            break;
        default:
            enforce(false, "invalid operation");
        }
        code[old_cnt] = ["stop"];
    }
    return true;

}

long solve2(string input = defaultinput!8)
{
    string[][] code = input.parser;
    string flip(string op)
    {
        if (op == Ops.jmp || op == Ops.nop)
        {
            return op == Ops.jmp ? Ops.nop : Ops.jmp;
        }
        return op;
    }

    long changed_statment = 0;
    long acc;
    auto code_copy = appender!(string[][]);
    code_copy.reserve(code.length);
    do
    {
        code_copy.clear();
        string[][] c = code.map!(y => y.map!(x => x.dup.to!string).array).array;
        code_copy.put(c);
        while (
            code_copy.data[changed_statment][0] == Ops.acc)
        {
            changed_statment++;
        }
        code_copy.data[changed_statment][0] = flip(code_copy.data[changed_statment][0]);
        // format!"flip %s at %d"(code_copy.data[changed_statment], changed_statment).writeln;
        changed_statment++;
    }
    while (!simulate(code_copy.data, acc));
    return acc;
}

void day8()
{
    print_result(8, solve, solve2);
}
