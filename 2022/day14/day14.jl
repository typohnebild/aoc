partition2(it) = Iterators.partition(it, 2)
path_split(line) = split(line, " -> ")
coord_split(coord) = split(coord, ",")
parseInt(str) = parse(Int, str)
get_paths(file) = eachline("test.txt") .|> path_split .|> (x -> coord_split.(x)) .|> Iterators.flatten .|> (x -> parseInt.(x)) .|> partition2 .|> collect .|> (z-> Iterators.map((y -> CartesianIndex(y...)), z))


function read_rocks(file)
    blocked = Dict()
    
    for path in eachline(file) .|> (line -> split(line, " -> "))
        parsed = path .|> (y -> split(y , ",") .|> (z -> parse(Int, z)))
        for (index, rock) in enumerate(parsed[2:end])
            
        end
    end
end

