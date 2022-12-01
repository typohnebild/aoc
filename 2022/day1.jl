function day1_1(file)
    cur_cal = 0
    max_cal = 0
    for line in eachline(file)
        if line == ""
            max_cal = max(max_cal, cur_cal)
            cur_cal = 0
        else
            cur_cal += parse(Int64, line)
        end
    end
    max_cal = max(max_cal, cur_cal)
    println(max_cal)
end

function day1_2(file)
    cals = Vector{Int64}()
    cur_cal = 0
    for line in eachline(file)
        if line == ""
            push!(cals, cur_cal)
            cur_cal = 0
        else
            cur_cal += parse(Int64, line)
        end
    end
    push!(cals, cur_cal)
    println(cals)
    partialsort!(cals, 3, rev=true)
    println(sum(cals[1:3]))
end
