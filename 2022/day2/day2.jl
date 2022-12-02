@enum Items begin
    Rock
    Paper
    Scissors
end

@enum GameState begin
    Lose
    Draw
    Win
end

function mapping(char)
    if char == 'A' || char == 'X'
        return Rock
    elseif char == 'B' || char == 'Y'
        return Paper
    elseif char == 'C' || char == 'Z'
        return Scissors
    else
        error(string("Invalid char ", char))
    end
end

function wins(lhs::Items, rhs::Items)
    if lhs == Rock
        return rhs == Scissors
    elseif lhs == Paper
        return rhs == Rock
    elseif lhs == Scissors
        return rhs == Paper
    end
end

function game(me::Items, opp::Items)
    if me == opp
        return 3
    elseif wins(me, opp)
        return 6
    else
        return 0
    end
end

function value(item::Items)
    if item == Rock
        return 1
    elseif item == Paper
        return 2
    elseif item == Scissors
        return 3
    end
end

function points(state::GameState)
    if state == Draw
        return 3
    elseif state == Lose
        return 0
    elseif state == Win
        return 6
    end
end

function choose_item(opp::Items, target_state::GameState)
    if target_state == Draw
        return opp
    end
    if target_state == Lose
        for pos in 0:2
            if wins(opp, Items(pos))
                return Items(pos)
            end
        end
    end
    if target_state == Win
        for pos in 0:2
            if wins(Items(pos), opp)
                return Items(pos)
            end
        end
    end

end

function part1(file)
    score = 0
    for line in eachline(file)
        lhs, rhs = split(line, " ")
        opp = mapping(lhs[1])
        me = mapping(rhs[1])
        new_score = game(me, opp) + value(me)
        score += new_score
    end
    score
end

function part2(file)
    score = 0
    for line in eachline(file)
        lhs, rhs = split(line, " ")
        opp = mapping(lhs[1])
        target_state = GameState(rhs[1] - 'X')
        me = choose_item(opp, target_state)
        score += value(me) + points(target_state)
    end
    score
end
