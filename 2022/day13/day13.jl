split_into_pairs(input) = split(input, "\n\n")
split_pairs(p) = split(p, "\n")
parse_input(file) = eachline(file) |> (x -> Iterators.filter(!=(""), x)) .|> (vec -> eval(Meta.parse(vec)))
group_by(x) = Iterators.partition(x, 2) |> collect

@enum Order begin
    correct = -1
    next = 0
    invalid = 1
end

compare(lhs::Int, rhs::Int) = Order(sign(lhs - rhs))

function compare(lhs::Vector, rhs::Vector)
    for (l, r) in zip(lhs, rhs)
        state = compare(l, r)
        if state != next
            return state
        end
    end
    return Order(sign(length(lhs) - length(rhs)))
end
compare(lhs::Int, rhs::Vector) = compare([lhs], rhs)
compare(lhs::Vector, rhs::Int) = compare(lhs, [rhs])

function part1(file)
    right_order = []
    for (index, (lhs, rhs)) in enumerate(parse_input(file) |> group_by)
        state = compare(lhs, rhs)
        println("$lhs $rhs $state")
        if state != invalid
            push!(right_order, index)
        end
    end
    right_order |> sum
end

function part2(file)
    input = parse_input(file)
    divider = [[[2]], [[6]]]
    append!(input, divider)
    lt(lhs, rhs) = compare(lhs, rhs) != invalid
    sort!(input, lt=lt)
    divider .|> (d -> findall(==(d), input)[1]) |> (x -> reduce(*, x))
end
