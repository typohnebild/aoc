
split_in_halves(str::String) = str[1:div(end, 2)], str[div(end, 2)+1:end]
find_duplicate(first::String, second::String) = intersect(Set(first), Set(second))
find_duplicate((first, second)::Tuple{String, String}) = find_duplicate(first, second)

import Base
struct Elf_Iterator
    file::String
end

function advance(state::Iterators.Stateful)
    if !isempty(state)
        Iterators.take(state, 3), state
    end
end

function Base.iterate(elf_iter::Elf_Iterator)
    state = Iterators.Stateful(eachline(elf_iter.file))
    advance(state)
end
Base.iterate(_::Elf_Iterator, state::Iterators.Stateful) = advance(state)


function priority(item::Char)
    if islowercase(item)
        return item - 'a' + 1
    else
        return item - 'A' + 27
    end
end

part1_1(file) = sum(priority(item) for item in Iterators.flatten(find_duplicate(split_in_halves(line)...) for line in eachline(file)))
part1_2(file) = (split_in_halves(line) |> (bag -> find_duplicate(bag...)) for line in eachline(file)) |> Iterators.flatten |> (flat -> Iterators.map(dup -> priority(dup), flat)) |> sum
part1_3(file) = eachline(file) |> (lines -> Iterators.map(line -> find_duplicate(split_in_halves(line)...), lines)) |> Iterators.flatten |> (flat -> Iterators.map(dup -> priority(dup), flat)) |> sum
# less lazy i think
part1_4(file) = eachline(file) |> lines -> split_in_halves.(lines) |> g -> find_duplicate.(g) |> Iterators.flatten |> i -> priority.(i) |> sum
part1_5(file) = eachline(file) .|> split_in_halves .|> find_duplicate |> Iterators.flatten .|> priority |> sum


part2_1(file) = sum(priority(badge) for badge in Iterators.flatten(intersect(f, s, t) for (f, s, t) in Elf_Iterator(file)))
part2_2(file) = Elf_Iterator(file) |> (groups -> Iterators.map(g -> intersect(g...), groups)) |> Iterators.flatten |> (flat -> Iterators.map(badge -> priority(badge), flat)) |> sum
part2_3(file) = Elf_Iterator(file) |> (groups -> Iterators.map(g -> intersect(g...), groups)) |> Iterators.flatten |> badge -> priority.(badge) |> sum
