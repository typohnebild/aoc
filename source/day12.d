import std;

enum Instruction
{
    North = 'N',
    South = 'S',
    East = 'E',
    West = 'W',
    Forward = 'F',
    Left = 'L',
    Right = 'R'
}

enum Dir
{
    North = 0,
    East = 90,
    South = 180,
    West = 270,
}

class Base
{
    int x, y;
    Dir direction = Dir.East;
    void move(string str)
    {
        char i;
        int val;
        str.formattedRead!"%c%d"(i, val);
        handle_instruction(cast(Instruction) i, val);
    }

    void apply_movement(Dir d, int val)
    {
        final switch (d)
        {
        case Dir.North:
            y += val;
            break;
        case Dir.South:
            y -= val;
            break;
        case Dir.East:
            x += val;
            break;
        case Dir.West:
            x -= val;
            break;
        }
    }

    abstract void handle_instruction(Instruction i, int val);

    @property int hamming_distance()
    {
        return abs(x) + abs(y);
    }
}

class Ship : Base
{
    override void handle_instruction(Instruction i, int val)
    {
        final switch (i)
        {
        case Instruction.North:
            apply_movement(Dir.North, val);
            break;
        case Instruction.South:
            apply_movement(Dir.South, val);
            break;
        case Instruction.East:
            apply_movement(Dir.East, val);
            break;
        case Instruction.West:
            apply_movement(Dir.West, val);
            break;
        case Instruction.Forward:
            apply_movement(direction, val);
            break;
        case Instruction.Right:
            direction = cast(Dir)((direction + val) % 360);
            break;
        case Instruction.Left:
            direction = cast(Dir)((direction + 720 - val) % 360);
        }
    }

    override string toString() const
    {
        return format!"Ship at x: %d y: %d with direction %s"(x, y, direction);
    }
}

class Waypoint : Base
{
    this()
    {
        x = 10;
        y = 1;
    }

    Ship s = new Ship();
    override void handle_instruction(Instruction i, int val)
    {
        final switch (i)
        {
        case Instruction.North:
            apply_movement(Dir.North, val);
            break;
        case Instruction.South:
            apply_movement(Dir.South, val);
            break;
        case Instruction.East:
            apply_movement(Dir.East, val);
            break;
        case Instruction.West:
            apply_movement(Dir.West, val);
            break;
        case Instruction.Forward:
            s.apply_movement(Dir.North, y * val);
            s.apply_movement(Dir.East, x * val);
            break;
        case Instruction.Right:
            rotate(val);
            break;
        case Instruction.Left:
            rotate((360 - val));
        }
        write(i, val, " ");
        this.writeln;
    }

    override string toString() const
    {
        return format!"Waypoint at x: %d y: %d with ship at %s"(x, y, s);
    }

    @property override int hamming_distance()
    {
        return s.hamming_distance;
    }

    void rotate(int degree)
    {
        if (degree == 180)
        {
            x *= -1;
            y *= -1;
        }
        if (degree == 90)
        {
            swap(x, y);
            y *= -1;
        }
        else if (degree == 270)
        {
            swap(x, y);
            x *= -1;
        }
    }
}

string[] parse(in string input = "input")
{
    return File(input).byLine().map!(to!string).array;

}

auto solve(in string[] instructions)
{
    Ship s = new Ship();
    instructions.each!(x => s.move(x));
    return s.hamming_distance();
}

auto solve2(in string[] instructions)
{
    Waypoint w = new Waypoint();
    instructions.each!(x => w.move(x));
    return w.hamming_distance();
}

void main()
{
    "input".parse.solve.writeln;
    "input".parse.solve2.writeln;
}

unittest
{

    auto example = [
        "F10",
        "N3",
        "F7",
        "R90",
        "F11",
        "L90",
        "R90",
        "L180",
        "R180",

    ];
    assert(example.solve == 25);
    assert(example.solve2 == 286);
}
