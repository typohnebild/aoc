module day7;
import util;

import std;

alias Child = Tuple!(uint, string);
alias Children = Tuple!(uint, string)[];
alias Graph = Children[string];

string[] parse_input(in string input = defaultinput!7)
{
    return File(input).byLine.map!(to!string).array;
}

Graph build_isin_graph(string[] list)
{

    Graph bags;
    auto pattern = regex(r"(\d) ([a-z]+ [a-z]+) bags?");
    foreach (item; list)
    {
        auto outer = item.matchFirst(regex(r"([a-z]+ [a-z]+) bags"))[1];
        auto splits = item.matchAll(pattern);
        foreach (child; splits)
        {
            uint count = child[1].strip.to!uint;
            bags[child[2]] ~= [tuple(count, outer)];
        }
        bags.require(outer, []);

    }
    return bags;
}

Graph build_contains_graph(string[] list)
{

    Graph bags;
    auto pattern = regex(r"(\d) ([a-z]+ [a-z]+) bags?");
    foreach (item; list)
    {
        auto outer = item.matchFirst(regex(r"([a-z]+ [a-z]+) bags"))[1];
        bags.require(outer, []);
        auto splits = item.matchAll(pattern);
        foreach (child; splits)
        {
            uint count = child[1].strip.to!uint;
            bags[outer] ~= [tuple(count, child[2])];
        }

    }
    return bags;
}

Children solve(Graph bags)
{
    Children queue;
    queue ~= bags["shiny gold"];
    size_t cur_idx = 0;
    while (cur_idx < queue.length)
    {
        auto cur = queue[cur_idx];
        if (cur[1] in bags)
        {
            queue ~= bags[cur[1]];
        }
        cur_idx++;
    }
    return queue.sort!((a, b) => a[1] < b[1])
        .uniq!((a, b) => a[1] == b[1])
        .array;
}

long solve2(const ref Graph bags, string cur)
{
    if (bags[cur].length == 0)
    {
        return 0;
    }
    long ret = 0;
    foreach (child; bags[cur])
    {
        ret += child[0] + child[0] * solve2(bags, child[1]);

    }
    return ret;

}

void day7()
{
    auto i = parse_input;
    auto isin_graph = i.build_isin_graph;
    auto contains_graph = i.build_contains_graph;

    print_result(7, isin_graph.solve.count, contains_graph.solve2("shiny gold"));
}
