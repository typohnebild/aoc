module day17;
import util;

import std;

enum Cube
{
    active = '#',
    inactive = '.'
}

struct Coord
{
    int x, y, z = 0, w = 0;
}

Cube[Coord] strtopocket(in string[] init)
{
    Cube[Coord] ret;

    init.enumerate.each!(row => row.value.enumerate.each!(
            (col) {
            if (col.value == Cube.active)
            {
                ret[Coord(col.index.to!int, row.index.to!int)] = Cube.active;
            }
        }
    ));
    return ret;
}

auto get_neigbours(size_t dim = 3)(Coord p)
{
    static if (dim == 3)
    {
        return cartesianProduct(iota(-1, 2), iota(-1, 2), iota(-1, 2)).filter!(
                a => a[0] != 0 || a[1] != 0 || a[2] != 0)
            .map!(a => Coord(p.x + a[0], p.y + a[1], p.z + a[2]));

    }
    else
    {
        return cartesianProduct(iota(-1, 2), iota(-1, 2), iota(-1, 2), iota(-1, 2)).filter!(
                a => a[0] != 0 || a[1] != 0 || a[2] != 0 || a[3] != 0)
            .map!(a => Coord(p.x + a[0], p.y + a[1], p.z + a[2], p.w + a[3]));

    }
}

auto count_active(size_t dim = 3)(in ref Cube[Coord] pocket, in Coord p)
{
    return p.get_neigbours!(dim)
        .filter!(neig => neig in pocket)
        .count;
}

auto solve(size_t dim = 3)(in string init, size_t iter = 1)
{
    auto pocket = init.splitter("\n").array.strtopocket;
    foreach (_; 0 .. iter)
    {
        auto potential = chain(pocket.keys, pocket.keys.map!(x => x.get_neigbours!dim).joiner).uniq;
        auto new_active = potential.filter!((x) {
            auto active = pocket.count_active!dim(x);
            if (x in pocket)
            {
                return active == 2 || active == 3;
            }
            else
            {
                return active == 3;
            }
        });
        Cube[Coord] new_pocket;
        new_active.each!(x => new_pocket[x] = Cube.active);
        pocket = new_pocket;

    }
    return pocket.length;
}

void day17()
{
    print_result(17, defaultinput!17.readText.solve(6),
            defaultinput!17.readText.solve!4(6));
}

unittest
{
    auto init = ".#.\n..#\n###";

    assert(solve(init, 1) == 11);
    assert(solve(init, 2) == 21);
    assert(solve(init, 3) == 38);

    assert(solve!4(init, 1) == 29);

}
