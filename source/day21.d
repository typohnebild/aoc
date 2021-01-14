module day21;
import std;
import util : print_result;

immutable pattern = r"^(.*) \(contains (.*)\)$";

auto solve(in string input, out string list)
{
    int[string] all_ingredients;
    string[][string] dict;
    foreach (line; input.splitter("\n"))
    {
        auto hit = line.matchFirst(pattern);
        auto ingredients = hit[1].split(" ").sort.array;
        auto allergens = hit[2].split(", ");
        ingredients.each!(ing => all_ingredients[ing]++);
        foreach (allergen; allergens)
        {
            if (!(allergen in dict))
            {
                dict[allergen] = ingredients.array;
            }
            else
            {
                auto already = dict[allergen];
                dict[allergen] = setIntersection(already, ingredients).array;
            }
        }
    }
    while (dict.byValue.any!(x => x.length != 1))
    {
        foreach (entry; dict.byKeyValue)
        {
            if (entry.value.length == 1)
            {
                dict.byValue
                    .filter!(x => x.length != 1)
                    .each!((ref x) => x = x.remove!(y => y == entry.value.front));
            }
        }
    }
    list = dict.byKeyValue
        .array
        .sort!((a, b) => a.key < b.key)
        .filter!(x => x.value.length == 1)
        .map!(x => x.value.front)
        .join(",").to!string;

    auto all_possible = dict.values.join.sort.uniq;
    return all_ingredients.byKeyValue
        .filter!(x => !all_possible.canFind(x.key))
        .map!(x => x.value)
        .sum;
}

void day21()
{
    string list;
    auto solution1 = "inputs/input21".readText.strip.solve(list);
    print_result(21, solution1, list);
}

unittest
{
    string list;
    assert(test_input.solve(list) == 5);
    assert(list == "mxmxvkd,sqjhc,fvjkl");
}

immutable test_input =
    r"mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)";
