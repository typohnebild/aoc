read_input(file) = eachline(file) .|> line -> collect((parse(Int, x) for x in line))

function visable(grid, i, j)
    is_smaller(x) = (x < grid[i, j])
    to_right = grid[begin:i-1, j] .|> is_smaller
    to_left = grid[i+1:end, j] .|> is_smaller
    to_top = grid[i, begin:j-1] .|> is_smaller
    to_bottom = grid[i, j+1:end] .|> is_smaller
    return all(to_top) || all(to_left) || all(to_right) || all(to_bottom)
end

function sum_visable(input_mat)
    rows, cols = size(input_mat)
    ret = 0
    for i in 2:rows-1
        for j in 2:cols-1
            if visable(input_mat, i, j)
                ret += 1
            end
        end
    end
    ret + 2 * rows + 2 * (cols - 2)
end

function count_vis(view, cur_height)
    ret = 0
    for n in view
        ret += 1
        if n >= cur_height
            break
        end
    end
    # println(view, "  ", cur_height, " ", ret)
    ret
end

function scenic_score(grid, i, j)
    to_right = grid[begin:i-1, j]|> reverse |> x -> count_vis(x, grid[i, j])
    to_left = grid[i+1:end, j] |> x -> count_vis(x, grid[i, j])
    to_top = grid[i, begin:j-1] |> reverse |> x -> count_vis(x, grid[i, j])
    to_bottom = grid[i, j+1:end] |> x -> count_vis(x, grid[i, j])
    Iterators.reduce(*, [to_top, to_right, to_left, to_bottom])
end


part1(file) = hcat(read_input(file)...) |> sum_visable

function part2(file)
    grid = hcat(read_input(file)...)
    rows, cols = size(grid)
    ret = 0
    for i in 2:rows-1
        for j in 2:cols-1
            cur = scenic_score(grid, i, j)
            if cur > ret
                println(i,j, cur)
                ret = cur
            end
        end
    end
    ret
end

