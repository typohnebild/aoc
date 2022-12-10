import Base
mutable struct ComputeState
    op_stream::Iterators.Stateful
    X::Int
    cycles_to_do::Int
    X_update::Int
end
struct XIterator
    file::String
end

function advance(state::ComputeState)
    if isempty(state.op_stream)
        return nothing
    end
    if state.cycles_to_do == 0
        state.X += state.X_update
        X_update, cycles_to_do = update_rule(popfirst!(state.op_stream))
        state.X_update = X_update
        state.cycles_to_do = cycles_to_do
    end
    state.cycles_to_do -= 1
    return state.X, state
end

function Base.iterate(iter::XIterator)
    op_stream = Iterators.Stateful(eachline(iter.file))
    state = ComputeState(op_stream, 1, 0, 0)
    return advance(state)
end
Base.iterate(_::XIterator, state::ComputeState) = advance(state)

function update_rule(line::String)
    if line == "noop"
        return 0, 1
    end
    return parse(Int, split(line, " ")[2]), 2
end



function part1(file)
    # cycle = 1
    # X = 1
    res = 0
    relevant_cycle = [20, 60, 100, 140, 180, 220]
    for (cycle, X) in enumerate(XIterator(file))
        if cycle in relevant_cycle
            println(X, "  ", cycle)
            res += X * cycle
        end
    end
    # for line in eachline(file)
    #     X_update, cycles_to_do = update_rule(line)
    #     for i in 1:cycles_to_do
    #         cycle += 1
    #         if i == cycles_to_do
    #             X += X_update
    #         end
    #         if cycle in relevant_cycle
    #             println(cycle, " ", X)
    #             res += X * cycle
    #         end
    #     end
    # end
    res
end
printscreen(screen::BitMatrix) = screen .|> (x -> (x ? '#' : '.')) |> x -> join.(eachrow(x))

function part2(file)
    cycle = 1
    X = 1
    screen = falses(6, 40)
    cur_row = 1
    for line in eachline(file)
        X_update, cycles_to_do = update_rule(line)
        for _ in 1:cycles_to_do
            crt = (cycle - 1) % 40
            if abs(crt - X) <= 1
                screen[cur_row, crt+1] = true
            end
            cycle += 1
            if cycle % 40 == 0
                cur_row += 1
            end
        end
        X += X_update

    end
    screen
end
