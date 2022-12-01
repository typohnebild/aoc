module day19;
import std;
import util : print_result;

auto get_rules(in string str)
{
    return str.split("\n").map!(x => x.split(": "))
        .map!(x => tuple(x[0].to!int, x[1]))
        .assocArray;
}

string build_regex(ref string[int] rules, int rule_id, bool part2 = false)
{
    auto rule = rules[rule_id];
    if (rule.startsWith('"'))
    {
        return rule[1].to!string;
    }

    string build_helper(string opts)
    {
        return opts.split(" ").map!(x => memoize!build_regex(rules, x.to!int, part2))
            .joiner
            .to!string;
    }

    if (part2)
    {
        if (rule_id == 8)
        {
            return "^" ~ memoize!build_regex(rules, 42, part2) ~ "+?";
        }
        if (rule_id == 11)
        {
            auto r42 = memoize!build_regex(rules, 42, part2);
            auto r31 = memoize!build_regex(rules, 31, part2);
            auto opt = iota(1, 12).map!(n => format!"%s{%d}(%s){%d}"(r42, n, r31, n)).join("|");
            return format!"(%s)"(opt);
        }
    }

    if (rule.canFind("|"))
    {
        auto ret = "(";
        auto splits = rule.split(" | ");
        foreach (opt; splits)
        {
            ret ~= build_helper(opt);
            ret ~= "|";
        }
        ret = ret[0 .. $ - 1] ~ ")";
        return ret;
    }
    return build_helper(rule);
}

auto test_pattern(string pattern, string[] msgs)
{
    auto reg = pattern.regex;
    return msgs.filter!((msg) {
        auto res = msg.matchFirst(reg);
        return !res.empty && res.front == msg;
    }).count;
}

auto solve(in string input, in bool part2 = false)
{
    auto content = input.readText.splitter("\n\n");
    auto rules = content.front.get_rules;
    auto pattern = build_regex(rules, 0, part2);
    content.popFront;
    return test_pattern(pattern, content.front.strip.split("\n"));
}

void day19()
{
    auto solution1 = solve("inputs/input19");
    auto solution2 = solve("inputs/input19", true);
    print_result(19, solution1, solution2);
}

unittest
{
    auto rules = test_rules.get_rules;
    auto pattern = build_regex(rules, 0);
    auto msgs = test_msg.strip.split("\n");
    assert(test_pattern(pattern, msgs) == 2);
    assert(solve("inputs/input19_test", false) == 3);
    assert(solve("inputs/input19_test", true) == 12);
}

immutable test_rules =
    `0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"`;

immutable test_msg =
    r"ababbb
bababa
abbbab
aaabbb
aaaabbb
";
