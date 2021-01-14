module day22;
import std;
import util;

auto get_decks(in string input)
{
    return input.split("\n\n").map!(x => x.split("\n").remove(0))
        .map!(player => player.map!(to!int).array)
        .array;

}

auto play(int[] deck1, int[] deck2)
{
    while (!deck1.empty && !deck2.empty)
    {
        if (deck1.front < deck2.front)
        {
            deck2 ~= [deck2.front, deck1.front];
        }
        else
        {
            deck1 ~= [deck1.front, deck2.front];
        }
        deck1.popFront;
        deck2.popFront;
    }
    if (deck1.empty)
    {
        return deck2;
    }
    return deck1;

}

auto calc_score(int[] deck)
{
    return zip(iota(1, deck.length + 1).retro, deck).map!(x => x[0] * x[1]).sum;
}

bool play_recurse(int[] deck1, int[] deck2, out int[] winner)
{
    int[][] player1_prev = [];
    int[][] player2_prev = [];

    while (!deck1.empty && !deck2.empty)
    {
        if (player1_prev.any!(x => x.equal(deck1)) && player2_prev.any!(x => x.equal(deck2)))
        {
            return true;
        }
        player1_prev ~= deck1.dup;
        player2_prev ~= deck2.dup;
        int cur1 = deck1.front;
        int cur2 = deck2.front;
        deck1.popFront;
        deck2.popFront;
        bool player1wins;
        if (cur1 <= deck1.length && cur2 <= deck2.length)
        {
            int[] tmp;
            player1wins = play_recurse(deck1[0 .. cur1].dup, deck2[0 .. cur2].dup, tmp);
        }
        else
        {
            player1wins = cur1 > cur2;
        }
        if (player1wins)
        {
            deck1 ~= [cur1, cur2];
        }
        else
        {
            deck2 ~= [cur2, cur1];
        }
    }
    if (deck2.empty)
    {
        winner = deck1;
        return true;
    }
    winner = deck2;
    return false;
}

auto solve1(in string input)
{

    auto decks = input.get_decks;
    auto winner = play(decks[0], decks[1]);
    return winner.calc_score;
}

auto solve2(in string input)
{
    auto decks = input.get_decks;
    int[] winner;
    play_recurse(decks[0], decks[1], winner);
    return winner.calc_score;
}

void day22()
{
    auto solution1 = solve1("inputs/input22".readText.strip);
    auto solution2 = solve2("inputs/input22".readText.strip);
    print_result(22, solution1, solution2);
}

unittest
{
    assert(solve1(test_input) == 306);
    assert(solve2(test_input) == 291);
}

immutable test_input =
    r"Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10";
