pattern = r"(\d+)-(\d+),(\d+)-(\d+)"

is_full_contained(l1, o1, l2, o2) = (l1 <= l2 && o2 <= o1) || (l2 <= l1 && o1 <= o2)

no_overlap(l1, o1, l2, o2) = o1 < l2 || o2 < l1

parse_pairs(file) = eachline(file) .|> (line -> match(pattern, line).captures) .|> (line -> (line .|> e -> parse(Int64, e)))

part1(file) = parse_pairs(file) .|> (assignments -> is_full_contained(assignments...)) |> count
part2(file) = parse_pairs(file) .|> (assignments -> !no_overlap(assignments...)) |> count
