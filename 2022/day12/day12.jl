read_grid(file) = reduce(vcat, permutedims.(collect.(eachline(file))))
TARGET = 'E'
directions = [CartesianIndex(-1, 0), CartesianIndex(1, 0), CartesianIndex(0, 1), CartesianIndex(0, -1)]

function part1(file)
    grid = read_grid(file)
    start = findall(==('S'), grid)[1]
    solutions = []
    in_grid(po) = 1 <= po[1] && 1 <= po[2] && po[1] <= size(grid)[1] && po[2] <= size(grid)[2]
    function height_diff(lhs, rhs)
        if lhs == 'S'
            return abs(rhs - 'a')
        elseif rhs == TARGET
            return abs(lhs - 'z')
        else
            return abs(lhs - rhs)
        end
    end
    work = [[start]]
    while !isempty(work)
        cur_path = pop!(work)
        if grid[cur_path[end]] == TARGET
            push!(solutions, cur_path)
            continue
        end
        pos = directions .|> d -> cur_path[end] + d
        for p in pos
            if in_grid(p) && !(p in cur_path)
                if height_diff(grid[cur_path[end]], grid[p]) <= 1
                    push!(work, [cur_path..., p])
                end
            end
        end
    end
    solutions .|> length |> minimum
end
