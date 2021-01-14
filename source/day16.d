import std;

auto parse_file(in string input = "input")
{
    return input.readText.splitter("\n\n")
        .map!(x => x.splitter("\n")).array;
}

auto get_condition(in string line)
{
    size_t low1, upper1, low2, upper2;
    line.split(": ")[1].formattedRead!"%d-%d or %d-%d"(low1, upper1, low2, upper2);

    return delegate(size_t x) {
        return (low1 <= x && x <= upper1) || (low2 <= x && x <= upper2);
    };
}

auto solve(in string input)
{
    auto content = input.parse_file;
    auto conditions = content[0].map!get_condition;

    return content[2].dropOne
        .map!(x => x.splitter(",").map!(to!size_t))
        .map!(ticket => ticket.filter!(field => conditions.all!(c => !c(field))))
        .joiner
        .sum;
}

auto solve2(in string input)
{
    auto content = input.parse_file;
    auto conditions = content[0].map!get_condition;
    auto valid_tickets = content[2]
        .dropOne
        .filter!(x => !x.empty)
        .map!(x => x.splitter(",").map!(to!size_t).array)
        .filter!(ticket => ticket.all!(field => conditions.any!(c => c(field))));

    valid_tickets.walkLength.writeln;
    size_t nooffields = conditions.walkLength;
    size_t[][] mapping;
    foreach (cond_idx, condition; enumerate(conditions))
    {
        mapping ~= nooffields.iota.filter!(
                idx => valid_tickets.all!(t => condition(t[idx]))).array;

    }
    while (mapping.any!(x => x.length > 1))
    {
        auto singeltons = mapping.filter!(x => x.length == 1)
            .map!(x => x.front);
        mapping.each!((ref line) {
            if (line.length > 1)
            {
                line = line.remove!(x => singeltons.any!(y => y == x));
            }
        });
    }
    auto dep = mapping.joiner.array[0 .. 6].map!(
            idx =>
            content[1]
            .dropOne.map!(x => x.split(",")
                .map!(to!long))
            .joiner.array[idx]
    );
    dep.writeln;
    return reduce!"a * b"(1L, dep);
}

void main()
{
    "input".solve.writeln;
}

unittest
{
    auto c1 = get_condition("departure location: 34-269 or 286-964");
    assert(c1(5) == false);
    assert(c1(34) == true);
    assert(c1(964) == true);
    assert("test_input".solve == 71);
    "input".solve2.writeln;
    // "test_input2".solve2;

}
