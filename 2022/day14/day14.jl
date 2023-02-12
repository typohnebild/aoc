partition2(it) = Iterators.partition(it, 2)
path_split(line) = split(line, " -> ")
coord_split(coord) = split(coord, ",")
parseInt(str) = parse(Int, str)
get_paths(file) = eachline("test.txt") .|> path_split .|> (x -> coord_split.(x)) .|> Iterators.flatten .|> (x -> parseInt.(x)) .|> partition2 .|> collect .|> (z-> Iterators.map((y -> CartesianIndex(y...)), z))

ROCK='#'
SAND='o'


function read_rocks(file)
    blocked = Dict()

    for path in eachline(file) .|> (line -> split(line, " -> "))
        parsed = path .|> (y -> split(y , ",") .|> (z -> parse(Int, z)))
        for (index, rock) in enumerate(parsed[2:end])
            start = CartesianIndex(parsed[index]...)
            stop = CartesianIndex(rock...)
            if stop < start
                start, stop = stop, start
            end
            for stone in start:stop
                blocked[stone] = '#'
            end
        end
    end
    return blocked
end

function next_pos(cur_pos, cave::Dict)
    possible_offsets = [[0, 1], [-1, 1], [1, 1]]
    for pos_offset in possible_offsets
        next = cur_pos + CartesianIndex(pos_offset...)
        if !haskey(cave, next)
            return next
        end
    end
    return cur_pos
end

function simulate_1(file)
    cave = read_rocks(file)
    abyss = keys(cave) .|> (x-> x[2]) |> maximum
    start = CartesianIndex(500, 0)
    cur = start
    next = cur
    i = 0
    while true
        while true
            next = next_pos(cur, cave)
            if next == cur
                println(next)
                break
            end
            if next[2] > abyss
                return i, cave
            end
            cur = next
        end
        cave[next] = SAND
        i += 1
        cur = start
    end
end

function next_pos2(cur_pos, cave::Dict, max_y)
    possible_offsets = [[0, 1], [-1, 1], [1, 1]]
    for pos_offset in possible_offsets
        next = cur_pos + CartesianIndex(pos_offset...)
        if (next[2] <= max_y) && !haskey(cave, next)
            return next
        end
    end
    return cur_pos
end

function simulate_2(file)
    cave = read_rocks(file)
    bottom = (keys(cave) .|> (x-> x[2]) |> maximum) + 1
    start = CartesianIndex(500, 0)
    cur = start
    next = cur
    i = 0
    while true
        while true
            next = next_pos2(cur, cave, bottom)
            if next == start
                return i, cave
            end
            if next == cur
                break
            end
            cur = next
        end
        cave[next] = SAND
        i += 1
        cur = start
    end
end
