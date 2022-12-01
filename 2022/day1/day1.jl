import Base
struct Elf_Iterator
    file::String
end

function advance(state::Iterators.Stateful)
    if !isempty(state)
        collect(Iterators.takewhile(!=(""), state)), state
    end
end

function Base.iterate(elf_iter::Elf_Iterator)
    state = Iterators.Stateful(eachline(elf_iter.file))
    advance(state)
end
Base.iterate(_::Elf_Iterator, state::Iterators.Stateful) = advance(state)

parse_snacks(elf) = map(snack -> parse(Int64, snack), elf)
parse_elfs(file) = Iterators.map(elf -> sum(parse_snacks(elf)), Elf_Iterator(file))

part1(file) = maximum(parse_elfs(file))
part2(file) = sum(+, partialsort!(collect(Iterators.takewhile(_ -> true, parse_elfs(file))), 1:3, rev=true))
