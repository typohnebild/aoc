module day11;
import util;

import std;

enum Tile
{
    floor = '.',
    empty = 'L',
    occupied = '#'
}

string[] parse(in string input = defaultinput!9)
{
    return File(input).byLine().map!(to!string).array;
}

auto solve(string[] field)
{
    size_t h = field.length;
    size_t w = field[0].length;
    auto get_adjacent(size_t i, size_t j)
    {
        auto start_i = i == 0 ? 0 : i - 1;
        auto stop_i = i == h - 1 ? i : i + 1;

        auto start_j = j == 0 ? 0 : j - 1;
        auto stop_j = j == w - 1 ? j : j + 1;
        return cartesianProduct(iota(start_i, stop_i + 1), iota(start_j, stop_j + 1)).filter!(
                a => !(a[0] == i && a[1] == j));
    }

    Tile single_step(size_t i, size_t j)
    {
        switch (field[i][j])
        {
        case Tile.empty:
            if (get_adjacent(i, j).count!(a => field[a[0]][a[1]] == Tile.occupied) == 0)
            {
                return Tile.occupied;
            }
            goto default;
        case Tile.occupied:
            if (get_adjacent(i, j).count!(a => field[a[0]][a[1]] == Tile.occupied) >= 4)
            {
                return Tile.empty;
            }
            goto default;
        default:
            return cast(Tile) field[i][j];
        }
    }

    string[] simulate()
    {
        auto newfield = new char[][](h, w);
        cartesianProduct(h.iota, w.iota).each!(x => newfield[x[0]][x[1]] = single_step(x[0], x[1]));
        return newfield.to!(string[]);
    }

    while (true)
    {
        string[] old_field = field.map!(x => x.dup.to!(string)).array;
        field = simulate();
        if (equal(old_field, field))
        {
            break;
        }
    }
    return field.map!(x => x.count!(x => x == Tile.occupied)).sum;

}

auto solve2(string[] field)
{
    size_t h = field.length;
    size_t w = field[0].length;
    auto get_visiable(size_t i, size_t j)
    {
        auto deltas = cartesianProduct([-1, 1, 0], [-1, 1, 0]).filter!((a) => !(a[0] == 0 && a[1] == 0));
        Tuple!(size_t, size_t)[] ret;
        foreach (delta; deltas)
        {
            long cur_i = i + delta[0];
            long cur_j = j + delta[1];
            while (0 <= cur_i && cur_i < h && 0 <= cur_j && cur_j < w)
            {
                if (field[cur_i][cur_j] != Tile.floor)
                {
                    ret ~= tuple(cast(size_t) cur_i, cast(size_t) cur_j);
                    break;
                }
                cur_i += delta[0];
                cur_j += delta[1];
            }
        }
        return ret;
    }

    Tile single_step(size_t i, size_t j)
    {
        switch (field[i][j])
        {
        case Tile.empty:
            if (get_visiable(i, j).count!(a => field[a[0]][a[1]] == Tile.occupied) == 0)
            {
                return Tile.occupied;
            }
            goto default;
        case Tile.occupied:
            if (get_visiable(i, j).count!(a => field[a[0]][a[1]] == Tile.occupied) >= 5)
            {
                return Tile.empty;
            }
            goto default;
        default:
            return cast(Tile) field[i][j];
        }
    }

    string[] simulate()
    {
        auto newfield = new char[][](h, w);
        cartesianProduct(h.iota, w.iota).each!(x => newfield[x[0]][x[1]] = single_step(x[0], x[1]));
        return newfield.to!(string[]);
    }

    while (true)
    {
        string[] old_field = field.map!(x => x.dup.to!(string)).array;
        field = simulate();
        if (equal(old_field, field))
        {
            break;
        }
    }
    return field.map!(x => x.count!(x => x == Tile.occupied)).sum;

}

void day11()
{
    print_result(11, defaultinput!11.parse.solve, defaultinput!11.parse.solve2);
}

unittest
{
    immutable string[] field = [
        "L.LL.LL.LL",
        "LLLLLLL.LL",
        "L.L.L..L..",
        "LLLL.LL.LL",
        "L.LL.LL.LL",
        "L.LLLLL.LL",
        "..L.L.....",
        "LLLLLLLLLL",
        "L.LLLLLL.L",
        "L.LLLLL.LL"
    ];
    assert(field.dup.solve == 37);
    assert(field.dup.solve2 == 26);
}
