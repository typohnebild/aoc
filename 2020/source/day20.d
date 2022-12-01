module day20;

import std;
import util : print_result;

class Tile
{
    long id;
    string[] _tile;
    this(in string raw)
    {
        auto splits = raw.split("\n").map!strip;
        splits[0].formattedRead!"Tile %d:"(id);
        splits.popFront;
        _tile = splits.array;
    }

    @property string top() const
    {
        return _tile.front;
    }

    @property string bottom() const
    {
        return _tile.back;
    }

    @property string left() const
    {
        return _tile.map!(x => x.front)
            .to!string;
    }

    @property string right() const
    {
        return _tile.map!(x => x.back)
            .to!string;
    }

    override string toString() const
    {
        return _tile.join("\n");
    }

    void filp_vertical()
    {
        _tile.reverse;
    }

    void filp_horizontal()
    {
        _tile = _tile.map!(x => x.dup.reverse.to!string).array;
    }

    bool isAdjacent(ref Tile lhs) const
    {
        static foreach (pair; cartesianProduct(["top", "bottom", "left", "right"], ["top", "bottom", "left", "right"]))
        {
            mixin(format!"if(this.%s.equal(lhs.%s)){return true;}"(pair[0], pair[1]));
            mixin(format!"if(this.%s.retro.equal(lhs.%s)){return true;}"(pair[0], pair[1]));
        }
        return false;
    }

}

struct PictureTile
{
    Tile mid;
    this(Tile mid)
    {
        this.mid = mid;
    }

    Tile top = null;
    Tile bottom = null;
    Tile left = null;
    Tile right = null;
}

auto get_Tiles(in string input)
{
    return input.strip.splitter("\n\n").map!(x => new Tile(x.strip)).array;
}

auto solve1(Tile[] tiles)
{
    return reduce!"a*b"(1L, tiles.filter!(tile => 2 == tiles.count!(y => y != tile && tile.isAdjacent(
            y)))
            .map!(tile => tile.id));
}

// void solve2(Tile[] tiles)
// {
//     auto neighbours = tiles.map!(tile => tiles.filter!(y => y != tile && tile.isAdjacent(y)));
//     auto zipped = zip(tiles, neighbours).assocArray;

//     auto corners = zipped.byKeyValue.filter!(x => x.value.walkLength == 2);
//     auto borders = zipped.byKeyValue.filter!(x => x.value.walkLength == 3);
//     PictureTile[] pic;
//     foreach(tile; tiles){
//         auto n = zipped[tile];
//     }
// }

void day20()
{

    auto solution1 = "inputs/input20".readText.get_Tiles.solve1;
    print_result(20, solution1, 0);
}

unittest
{

    auto tiles = test_input.get_Tiles;
    assert(tiles.solve1 == 20_899_048_083_289);
    // tiles.solve2;
}

immutable test_input = r"Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###

Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..

Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...

Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.

Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..

Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.

Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#

Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.

Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###...
";
