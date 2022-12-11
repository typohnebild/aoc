# import Base.GMP
NumberType = Int

mod_num::NumberType = 2*3*5*7*11*13*17*19*23


mutable struct Monkey
    id::NumberType
    items::Array{NumberType}
    new_operation::String
    div_test::NumberType
    if_true::NumberType
    if_false::NumberType
    inspection_cnt::NumberType
end
function apply_op(m::Monkey, old::NumberType)
    old = old % mod_num
    x = replace(m.new_operation, "old" => "$NumberType($old)")
    expr = Meta.parse(x)
    ret = eval(expr)
    ret % mod_num
end

monkey_pattern = r"Monkey (\d+):\n\s+Starting items: (\d+(, \d+)*)\n\s+Operation: ([^\n]+)\n\s+Test: divisible by (\d+)\n\s+If true: throw to monkey (\d+)\n\s+If false: throw to monkey (\d+)"
match_monkey(input) = match(monkey_pattern, input)

function match2monkey(matched)
    id = parse(NumberType, matched.captures[1])
    items = split(matched.captures[2], ", ") .|> x -> (parse(NumberType, x) % mod_num)
    new_operation = matched.captures[4]
    rest = matched.captures[5:end] .|> x -> parse(NumberType, x)
    Monkey(id, items, new_operation, rest..., 0)
end
parse_monkeys(file) = read(file, String) |> (x -> split(x, "\n\n")) .|> match_monkey .|> match2monkey

function play_round(monkeys, part1::Bool=true)
    for monkey in monkeys
        while !isempty(monkey.items)
            item = popfirst!(monkey.items)
            new_level = apply_op(monkey, item)
            if part1
                new_level = div(new_level, 3) % mod_num
            end
            target = new_level % monkey.div_test == 0 ? monkey.if_true : monkey.if_false
            push!(monkeys[target+1].items, new_level)
            monkey.inspection_cnt += 1
        end
    end
end
function play_game(monkeys, rounds, part1::Bool=true)
    for i in 1:rounds
        play_round(monkeys, part1)
        if i % 1000 == 0
            println("$i rounds done")
            println(monkeys)
        end
    end
    monkeys
end

function part1(file::String, rounds::Int=20)
    monkeys = parse_monkeys(file)
    monkeys = play_game(monkeys, rounds)
    monkeys .|> (m -> m.inspection_cnt) |> x -> partialsort(x, 1:2, rev=true) |> y -> reduce(*, y)
end

function part2(file::String, rounds::Int=10000)
    monkeys = parse_monkeys(file)
    monkeys = play_game(monkeys, rounds, false)
    monkeys .|> (m -> m.inspection_cnt) |> x -> partialsort(x, 1:2, rev=true) |> y -> reduce(*, y)
end
