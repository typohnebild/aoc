read_grid(file) = reduce(vcat, permutedims.(collect.(eachline(file))))
TARGET = 'E'
directions = [CartesianIndex(-1, 0), CartesianIndex(1, 0), CartesianIndex(0, 1), CartesianIndex(0, -1)]

function height_diff(from::Char, to::Char)
    if from == 'S'
        return to - 'a'
    elseif to == 'S'
        return 'a' - from
    elseif to == TARGET
        return 'z' - from
    elseif from == TARGET
        return 'z' - from
    else
        return to - from
    end
end

function build_graph(grid)
    in_grid(po) = 1 <= po[1] <= size(grid)[1] && 1 <= po[2] <= size(grid)[2]
    ret = Dict()
    for cur_pos in CartesianIndices(grid)
        neigbours = directions .|> (d -> cur_pos + d) |> (y -> filter(in_grid, y)) |> y -> filter(x -> height_diff(grid[x], grid[cur_pos]) <= 1, y)
        ret[cur_pos] = neigbours
    end
    ret
end


function shortestPath(grid, start)
    neighbours = build_graph(grid)
    visited = BitArray{2}(undef, size(grid))
    visited .= false
    distance = Array{Int64,2}(undef, size(grid))
    distance .= 1000_000
    distance[start] = 0
    queue = [keys(neighbours)...]
    by_distance(x::CartesianIndex{2}) = distance[x]

    while !isempty(queue)
        sort!(queue, by=by_distance)
        cur = popfirst!(queue)
        visited[cur] = true
        for n in neighbours[cur]
            if !visited[n]
                tmp_dist = distance[cur] + 1
                if tmp_dist < distance[n]
                    distance[n] = tmp_dist
                end
            end
        end
    end
    distance
end


function part1(file)
    grid = read_grid(file)
    target_pos = findall(==(TARGET), grid)[1]
    d = shortestPath(grid, target_pos)
    start = findall(==('S'), grid)[1]
    d[start]
end

function part2(file)
    grid = read_grid(file)
    # start = findall(==('S'), grid)[1]
    target_pos = findall(==(TARGET), grid)[1]
    as = collect(CartesianIndices(grid)) |> (y -> filter((x -> grid[x] == 'a'), y))
    distance = shortestPath(grid, target_pos)
    as .|> (a -> distance[a]) |> minimum
end

