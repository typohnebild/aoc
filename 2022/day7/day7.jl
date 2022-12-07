import Base

mutable struct Dir
    name::String
    sub_dir::Array{String}
    file_size::Int
end

function count_size(dir_name::String, dirs::Dict)
    size = 0
    dirs_to_parse = [dirs[dir_name]]
    while !isempty(dirs_to_parse)
        cur_dir = popfirst!(dirs_to_parse)
        for sd in cur_dir.sub_dir
            dirs_to_parse
            push!(dirs_to_parse, dirs[sd])
        end
        size += cur_dir.file_size
    end
    size
end

function get_dirs(file)
    lines = Iterators.Stateful(eachline(file))
    dirs = Dict()
    cur_path = []
    while !isempty(lines)
        cur_dir_name = split(popfirst!(lines), " ")[end]
        while cur_dir_name == ".."
            pop!(cur_path)
            cur_dir_name = split(popfirst!(lines), " ")[end]
        end
        push!(cur_path, cur_dir_name)
        cur_dir = Dir(cur_dir_name, [], 0)
        popfirst!(lines)
        cur_path_str = join(cur_path, "/")

        while !isempty(lines) && !startswith(peek(lines), "\$ cd")
            line = popfirst!(lines)
            splits = split(line, " ")
            if splits[begin] == "dir"
                push!(cur_dir.sub_dir, "$(cur_path_str)/$(string(splits[end]))")
            else
                cur_dir.file_size += parse(Int, splits[begin])
            end
        end
        if haskey(dirs, cur_dir.name)
            error("detected_duplicate")
        end
        dirs[cur_path_str] = cur_dir
    end
    dirs
end

function get_acc_sizes(dirs)
    Dict( n => count_size(n, dirs) for n in keys(dirs) )
end

function part1(file)
    dirs = get_dirs(file)
    sizes = get_acc_sizes(dirs)
    Iterators.filter(y-> y<= 100000, values(sizes)) |> sum
end

function part2(file)
    dirs = get_dirs(file)
    sizes = get_acc_sizes(dirs)
    all_mem = 70000000
    needed = 30000000
    free = all_mem - sizes["/"]
    to_free = needed - free
    Iterators.filter(y-> y >= to_free, values(sizes)) |> minimum
end

