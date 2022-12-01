module day4;
import std.stdio;
import std.file;
import std.string;
import std.array;
import std.algorithm;
import std.regex;
import std.conv : to;
import util;

immutable fields =
    [
        "byr",
        "iyr",
        "eyr",
        "hgt",
        "hcl",
        "ecl",
        "pid",
    ];

bool validbyr(int byr)
{
    return 1920 <= byr && byr <= 2002;
}

bool validiyr(int iyr)
{
    return 2010 <= iyr && iyr <= 2020;
}

bool valideyr(int eyr)
{
    return 2020 <= eyr && eyr <= 2030;
}

bool validhgt(string hgt)
{
    string scale = hgt[$ - 2 .. $];
    string value = hgt[0 .. $ - 2];
    try
    {
        int val = value.to!int;
        if (scale == "in")
        {
            return 59 <= val && val <= 76;
        }
        if (scale == "cm")
        {
            return 150 <= val && val <= 193;
        }
    }
    catch (Exception)
    {
    }
    return false;
}

bool validhcl(string hcl)
{
    return hcl.length == 7 && !hcl.matchAll(r"#[0-9a-z]{6}").empty;
}

bool validecl(string ecl)
{
    return ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].any!(a => a == ecl);

}

bool validpid(string pid)
{
    return pid.length == 9 && !pid.matchAll(r"[0-9]{9}").empty;
}

bool valid(string[] passport)
{
    foreach (field; passport)
    {
        string[] splits = field.split(":");
        switch (splits[0])
        {
        case "byr":
            if (!validbyr(splits[1].to!int))
            {
                // field.writeln;
                return false;
            }
            break;
        case "iyr":
            if (!validiyr(splits[1].to!int))
            {
                // field.writeln;
                return false;
            }
            break;
        case "eyr":
            if (!valideyr(splits[1].to!int))
            {
                // field.writeln;
                return false;
            }
            break;
        case "hgt":
            if (!validhgt(splits[1]))
            {
                // field.writeln;
                return false;
            }
            break;
        case "hcl":
            if (!validhcl(splits[1]))
            {
                // field.writeln;
                return false;
            }
            break;
        case "ecl":
            if (!validecl(splits[1]))
            {
                // field.writeln;
                return false;
            }
            break;
        case "pid":
            if (!validpid(splits[1]))
            {
                // field.writeln;
                return false;
            }
            break;
        default:
            break;
        }
    }
    return true;
}

string[][] read_input(string input = defaultinput!4)
{

    return input.readText.splitter("\n\n")
        .map!(x => x.splitter.array)
        .filter!(x => fields.all!(y => x.any!(z => z.startsWith(y))))
        .array;

}

ulong solve(string input = defaultinput!4)
{
    return input.read_input.count;
}

ulong solve2(string input = defaultinput!4)
{
    return input.read_input.count!valid;
}

void day4()
{
    print_result(4, solve, solve2);
}
