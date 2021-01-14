import std;

auto parse(in string input = "input")
{
    auto f = File(input);
    auto arival = f.readln.strip.to!long;
    auto timetable = f.readln
        .to!(string)
        .strip
        .splitter(",")
        .filter!isNumeric
        .map!(to!long)
        .array;
    return tuple(arival, timetable);
}

auto parse2(in string input = "input")
{
    auto f = File(input);
    f.readln.strip.to!long;
    return f.readln.strip.to!string;
}

auto next_bus(long arival, long[] timetable)
{
    return timetable.minElement!((a, b) => (a - (arival % a)) < (b - (arival % b)));
}

auto extended_euclid(T)(T a, T b)
{
    T x = 1, x_prime = 0, y = 0, y_prime = 1;
    T tmp;
    while (0 < b)
    {
        T q = a / b;
        tmp = a - b * q;
        a = b;
        b = tmp;

        tmp = x - x_prime * q;
        x = x_prime;
        x_prime = tmp;

        tmp = y - y_prime * q;
        y = y_prime;
        y_prime = tmp;
    }
    return tuple!("gcd", "x", "y")(a, x, y);
}

T inverse(T)(T x, T n)
{
    auto gcd = extended_euclid!(T)(n, x);
    enforce(gcd.gcd == 1);
    return (n + gcd.y) % n;
}

alias equation = Tuple!(long, "a", long, "m");

auto chinese_remainder(T)(equation[] equations)
{
    T M = reduce!((acc, eq) => acc * eq.m)(1L, equations);
    auto Mis = equations.map!(a => M / a.m);
    auto Nis = zip(equations, Mis).map!(a => inverse(a[1], a[0].m));
    return zip(equations, Mis, Nis).map!(a => a[0].a * a[1] * a[2]).sum % M;

}

auto solve(long arival, long[] timetable)
{
    auto bus = timetable.map!(x => tuple(x, (x - (arival % x))))
        .minElement!((a, b) => a[1] < b[1]);
    return bus[0] * bus[1];
}

auto solve2(string input)
{
    auto equations = input.splitter(',').enumerate
        .filter!(x => x.value.isNumeric)
        .map!((x) {
            long val = x.value.to!long;
            x.index.writeln;
            return equation((val - x.index % val) % val, val);
        }
        )
        .array;
    equations.writeln;
    return chinese_remainder!long(equations);
}

void main()
{
    auto x = "input".parse;
    solve(x[0], x[1]).writeln;
    parse2.solve2().writeln;
}

unittest
{
    assert(next_bus(939, [7, 13, 59, 31, 19]) == 59);
    assert(solve(939, [7, 13, 59, 31, 19]) == 295);
    assert("17,x,13,19".solve2 == 3417);
    assert("7,13,x,x,59,x,31,19".solve2 == 1_068_781);
    parse2.solve2().writeln;

}

unittest
{
    assert(extended_euclid(3876, 8462) == tuple(2, -1168, 535));
    assert(inverse(37, 101) == 71);
    auto eq = [equation(1, 2), equation(0, 3), equation(4, 5)];
    assert(chinese_remainder!long(eq) == 9);

}
