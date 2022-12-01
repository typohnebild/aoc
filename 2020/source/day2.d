module day2;
import util;

import std.stdio;
import std.regex;
import std.file;
import std.algorithm;
import std.format;

mixin template unpack()
{
    int min, max;
    char letter;
    string password;
    void read_line(char[] line)
    {
        line.formattedRead!"%d-%d %c: %s"(min, max, letter, password);
    }

}

bool valid1(char[] line)
{
    mixin unpack!();
    read_line(line);
    auto occurance = password.count!(
            a => a == letter);
    return min <= occurance && occurance <= max;
}

bool valid2(char[] line)
{
    mixin unpack;
    read_line(line);
    return (password[min - 1] == letter) ^ (password[max - 1] == letter);

}

ulong solve(alias func = valid1)(in string filename = defaultinput!2)
{
    return File(filename).byLine.count!func;
}

void day2()
{
    print_result(2, solve!valid1, solve!valid2);
}
