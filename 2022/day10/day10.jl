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

relevant(x::Int) = x in [20, 60, 100, 140, 180, 220]

function part1(file)
    res = 0
    for (cycle, X) in enumerate(XIterator(file))
        if relevant(cycle)
            # println(X, "  ", cycle)
            res += X * cycle
        end
    end
    res
end

part1_1(file) = Iterators.filter(x -> relevant(x[1]), enumerate(XIterator(file))) .|> (x -> (x[1] * x[2])) |> sum

printscreen(screen::BitMatrix) = screen .|> (x -> (x ? '#' : '.')) |> x -> join.(eachrow(x))

function part2(file)
    no_of_cols = 40
    screen = falses(6, no_of_cols)
    for (cycle, X) in enumerate(XIterator(file))
        crt = (cycle - 1) % no_of_cols
        cur_row = div(cycle, no_of_cols)
        if abs(crt - X) <= 1
            screen[cur_row+1, crt+1] = true
        end
        if cycle % 40 == 0
            cur_row += 1
        end
    end
    screen
end
