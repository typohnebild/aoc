
test1="mjqjpqmgbljsphdztnvjfqwrcgsmlb"
test2="bvwbjplbgvbhsrlpgdmjqwftvncz"
test3="nppdvjthqldpwncqszvftbrmjlhg"

function find_first_marker(datastream_buffer::String, buffer_size)
    for i in buffer_size:length(datastream_buffer)
        if length(Set(datastream_buffer[i+1-buffer_size:i])) == buffer_size
            return i
        end
    end
    error("found no marker")
end


part1(file) = eachline(file) .|> (buf -> find_first_marker(buf, 4))
part2(file) = eachline(file) .|> (buf -> find_first_marker(buf, 14))
