import std.range;
import std.format;

void main()
{
    static foreach (i; iota(1, 24))
    {
        mixin(format!"import day%d;"(i));
        mixin(format!"day%d.day%d();"(i, i));
    }
}
