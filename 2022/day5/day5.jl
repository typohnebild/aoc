function read_stacks(file)
    stackstring = readuntil(file, "\n\n")
    stacks = Dict{Int64,Array{Char}}()
    for line in reverse(split(stackstring, "\n")[1:end-1])
        l_iter = Iterators.Stateful(line)
        stack_idx = 1
        while true
            item = collect(Iterators.take(l_iter, 3))
            if item[2] != ' '
                if !haskey(stacks, stack_idx)
                    stacks[stack_idx] = [item[2]]
                else
                    push!(stacks[stack_idx], item[2])
                end
            end
            if isempty(l_iter)
                break
            end
            popfirst!(l_iter)
            stack_idx += 1
        end
    end
    stacks
end

command_pattern = r"move (\d+) from (\d+) to (\d+)"
function read_instructions(file)
    Iterators.dropwhile(x -> !startswith(x, "move"), eachline(file)) .|> (line -> match(command_pattern, line).captures) .|> line -> (line .|> x -> parse(Int64, x))
end

get_top_of_stacks(stacks) = sort!(collect(keys(stacks))) .|> (stack -> stacks[stack][end]) |> join


function part1(file)
    stacks = read_stacks(file)
    for (amount, from, to) in read_instructions(file)
        for _ in 1:amount
            push!(stacks[to], pop!(stacks[from]))
        end
    end
    get_top_of_stacks(stacks)
end

function part2(file)
    stacks = read_stacks(file)
    for (amount, from, to) in read_instructions(file)
        append!(stacks[to], stacks[from][end-amount+1:end])
        for _ in 1:amount
            pop!(stacks[from])
        end
    end
    get_top_of_stacks(stacks)
end
