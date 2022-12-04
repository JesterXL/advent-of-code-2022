app "AoC Day 3 - Bring Da Ruckus! WHO QWAN TEST!?"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

# Part 1
# Attempt 1 - 477, Correct! I'm starting to get lazy I'll never fail at life now, thanks Roc!


main =
    task =
        inputStr <- Path.fromStr "input.txt" |> File.readUtf8 |> Task.await
        part1 =
            Str.split inputStr "\n"
            |> List.keepIf pairIsContained
            |> List.len
        dbg part1
        # Stdout.write "Part 1: \(part1)\n"
        Stdout.write "Part 1:"
    Task.onFail task \_ -> crash "Failed to read and parse input"

pairIsContained = \pairStr ->
    Str.split pairStr ","
    |> List.map \ranges -> Str.split ranges "-"
    |> List.map \ranges -> { start: List.first ranges |> parseNum, datEndTho: List.last ranges |> parseNum }
    |> List.walk { keep: Bool.false, current: NoRange } \state, elem ->
        when state.current is
            NoRange ->
                { state & current: HasRange elem }
            HasRange rangeBruh ->
                if rangeBruh.start >= elem.start &&  rangeBruh.datEndTho <= elem.datEndTho then
                    { state & keep: Bool.true }
                else if elem.start >= rangeBruh.start &&  elem.datEndTho <= rangeBruh.datEndTho then
                    { state & keep: Bool.true }
                else
                    state
    |> .keep

parseNum = \result ->
    result |> Result.withDefault "0" |> Str.toU32 |> Result.withDefault 0