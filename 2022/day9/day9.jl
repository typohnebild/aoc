import Base.==
struct Pos
    x::Int
    y::Int
    Pos(x, y) = new(x, y)
end
==(lhs::Pos, rhs::Pos) = lhs.x == rhs.x && lhs.y == rhs.y

diff(lhs::Pos, rhs::Pos) = max(abs(lhs.x - rhs.x), abs(lhs.y - rhs.y))

function calc_tail_pos(head::Pos, tail::Pos)
    if diff(head, tail) <= 1
        return tail
    end
    if diff(head, tail) > 2
        error("invalid state $head, $tail")
    end
    x_dir = sign(head.x - tail.x)
    y_dir = sign(head.y - tail.y)
    return Pos(tail.x + x_dir, tail.y + y_dir)
end

function update_pos(head, cmd)
    if cmd == "R"
        return Pos(head.x + 1, head.y)
    elseif cmd == "L"
        return Pos(head.x - 1, head.y)
    elseif cmd == "U"
        return Pos(head.x, head.y + 1)
    elseif cmd == "D"
        return Pos(head.x, head.y - 1)
    end

end

function part1(file)
    head = Pos(1, 1)
    tail = Pos(1, 1)
    tail_was_there = Set([tail])
    for line in eachline(file)
        cmd, amount = split(line, " ")
        amount = parse(Int, amount)
        for _ in 1:amount
            head = update_pos(head, cmd)
            tail = calc_tail_pos(head, tail)
            push!(tail_was_there, tail)
        end
        println(head, " ", tail)
    end
    # println(tail_was_there)
    println(length(Set(tail_was_there)))
end

function part2(file)
    head = Pos(1,1)
    tails = [Pos(1,1) for _ in 1:9]
    tail_was_there = Set(tails)
    for line in eachline(file)
        cmd, amount = split(line, " ")
        amount = parse(Int, amount)
        for _ in 1:amount
            head = update_pos(head, cmd)
            tails[1] = calc_tail_pos(head, tails[1])
            for i in 2:9
                tails[i] = calc_tail_pos(tails[i-1], tails[i])
            end
            push!(tail_was_there, tails[9])
        end
    end
    # println(tail_was_there)
    println(length(Set(tail_was_there)))
end

