app "AoC Day 3 - Bring Da Ruckus! WHO QWAN TEST!?"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

# Part 1
# Attempt 1 - 7701, CORRECT! First try baby.:: Ben Stiller voice :: "Again. Again."

# Part 2
# Attempt 2 - 2644, CORRECT! First try. Man, I remember this being hard in all languages NOT Python.

main =
    task =
        inputStr <- Path.fromStr "input.txt" |> File.readUtf8 |> Task.await
        part1 = Str.split inputStr "\n" |> List.map sackify |> List.map utfToPriority |> List.map Num.toU32 |> List.sum |> Num.toStr
        part2 = Str.split inputStr "\n" |> chunk 3 |> List.map badgify |> List.sum |> Num.toStr
        Stdout.write "Part 1: \(part1)\nPart 2: \(part2)\n"
    Task.onFail task \_ -> crash "Failed to read and parse input"

sackify = \chars ->
    list = Str.toUtf8 chars
    { before, others } = List.split list (List.len list // 2)
    Set.intersection (Set.fromList before) (Set.fromList others) |> Set.toList |> List.get 0 |> Result.withDefault 0

utfToPriority = \utf ->
    if utf >= 97 && utf <= 122 then
        utf - 96
    else
        utf - 38

chunk = \sacks, size ->
    List.walk sacks { chunks: [], chunk: [], current: 0} \state, datSack ->
        if state.current + 1 >= size then
            { state & chunks: List.concat state.chunks [List.append state.chunk datSack], chunk: [], current: 0 }
        else
            { state & chunk: List.append state.chunk datSack, current: state.current + 1 }
    |> .chunks

badgify = \sacks ->
    List.map sacks Str.toUtf8 
    |> List.map safeMapFromUtf8 
    |> List.map Set.fromList 
    |> shrink # <-- took me 20 years to figure out
    |> List.map Set.toList
    |> List.map \item -> List.first item |> Result.withDefault "?"
    |> List.map \item -> Str.toUtf8 item |> List.first |> Result.withDefault 0 |> Num.toU32
    |> List.walk (Num.toU32 0) \state, elem ->
        state + utfToPriority elem

safeFromUtf8 = \utf ->
    Str.fromUtf8 [utf] |> Result.withDefault ""

safeMapFromUtf8 = \list ->
    List.map list safeFromUtf8

shrink = \sets ->
    results = 
        List.walk sets { matches: [], current: NoSet } \state, elem ->
            when state.current is
                NoSet ->
                    { state & current: CurrentSet elem }
                CurrentSet set ->
                    { state & matches: List.append state.matches (Set.intersection set elem), current: CurrentSet elem }
        |> .matches
    if List.len results > 1 then
        shrink results
    else
        results
