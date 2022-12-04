app "AoC Day 3 - Bring Da Ruckus! WHO QWAN TEST!?"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

# Part 1
# Attempt 1 - 477, Correct! I'm starting to get lazy I'll never fail at life now, thanks Roc!

# Part 2
# Attempt 1 - 266, failed, too low. Hrm...
# Attempt 2 - 1000, too high... wat.
# Attempt 3 - 266, wait, already guessed, this, lelz, whoops.
# Attempt 4 - 651, wrong. ok, wow.
# Attempt 5 (5 minute penalty) 353... wow, just wow. I suck.
# Attempt 6 - 830, MOOOAARRR UNIT TESTS FTW!!11oneone Thanks Roc test.


main =
    task =
        inputStr <- Path.fromStr "input.txt" |> File.readUtf8 |> Task.await
        part1 = Str.split inputStr "\n" |> List.keepIf pairIsContained |> List.len |> Num.toStr
        part2 = Str.split inputStr "\n" |> List.keepIf pairOverlaps |> List.len |> Num.toStr
        dbg part2
        Stdout.write "Part 1: \(part1)\nPart 2: \(part2)\n"
    Task.onFail task \_ -> crash "Failed to read and parse input"

parsePair = \pairStr ->
    Str.split pairStr ","
    |> List.map \ranges -> Str.split ranges "-"
    |> List.map \ranges -> { start: List.first ranges |> parseNum, end: List.last ranges |> parseNum }

pairIsContained = \pairStr ->
    parsePair pairStr
    |> List.walk { keep: Bool.false, current: NoRange } \state, elem ->
        when state.current is
            NoRange ->
                { state & current: HasRange elem }
            HasRange rangeBruh ->
                { state & keep: lineContains rangeBruh elem }
    |> .keep

pairOverlaps = \pairStr ->
    parsePair pairStr
    |> List.walk { overlaps: Bool.false, current: NoRange } \state, elem ->
        when state.current is
            NoRange ->
                { state & current: HasRange elem }
            HasRange rangeBruh ->
                { state & overlaps: lineIntersects rangeBruh elem }
    |> .overlaps
    
# A                    C       B                D
# -----------------------------------------------
# C                    A       D                B
# -----------------------------------------------
# D < A == true, lines are not overlapping

# B < C

pointBetween = \point, start, end ->
    point >= start && point <= end

lineContains = \a, b ->
    if a.start >= b.start &&  a.end <= b.end then
        Bool.true
    else if b.start >= a.start &&  b.end <= a.end then
        Bool.true
    else
        Bool.false
        
lineIntersects = \a, b ->
    if a.start > b.start && a.start <= b.end && a.end > b.end then
        Bool.true
    else if a.start < b.start && a.end >= b.start && a.end <= b.end then
        Bool.true
    else if lineContains a b then
        Bool.true
    else
        lineContains b a

parseNum = \result ->
    result |> Result.withDefault "0" |> Str.toU32 |> Result.withDefault 0

expect pointBetween 2 1 3 == Bool.true
expect pointBetween 1 1 3 == Bool.true
expect pointBetween 3 1 3 == Bool.true
expect pointBetween 4 1 3 == Bool.false
expect pointBetween 0 1 3 == Bool.false

expect lineIntersects { start: 2, end: 4} { start: 6, end: 8 } == Bool.false
expect lineIntersects { start: 2, end: 3} { start: 4, end: 5 } == Bool.false
expect lineIntersects { start: 5, end: 7} { start: 7, end: 9 } == Bool.true
expect lineIntersects { start: 2, end: 8} { start: 3, end: 7 } == Bool.true
expect lineIntersects { start: 6, end: 6} { start: 4, end: 6 } == Bool.true
expect lineIntersects { start: 2, end: 6} { start: 4, end: 8 } == Bool.true

# 2-4,6-8
# 2-3,4-5
# 5-7,7-9
# 2-8,3-7
# 6-6,4-6
# 2-6,4-8

# 5-7,7-9 overlaps in a single section, 7.
# 2-8,3-7 overlaps all of the sections 3 through 7.
# 6-6,4-6 overlaps in a single section, 6.
# 2-6,4-8 overlaps in sections 4, 5, and 6.
