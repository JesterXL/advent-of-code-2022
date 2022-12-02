app "AoC Day 2 - Rock Paper Scissors"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

# Part 1
# Attempt 1 - 10310, CORRECT! First try, baby. Again.

# Part 2
# Attempt 1 - 14859%, lol, I did NOT see that % sign at the end. I think
# I forgot a \n in the standard out, haha
# Attempt 2 - 14859, CORRECT... LELZ

main =
    task =
        inputStr <- Path.fromStr "input.txt" |> File.readUtf8 |> Task.await
        lines = Str.split inputStr "\n"
        totalScore = lines |> List.map parseLine |> List.sum |> Num.toStr
        part2Score = lines |> List.map parseLine2 |> List.sum |> Num.toStr
        Stdout.write "Part 1: \(totalScore)\nPart 2: \(part2Score)\n"

    Task.onFail task \_ -> crash "Failed to read and parse input"

parseLine = \lineStr ->
    when lineStr is
        "A X" -> 4
        "A Y" -> 8
        "A Z" -> 3
        "B X" -> 1
        "B Y" -> 5
        "B Z" -> 9
        "C X" -> 7
        "C Y" -> 2
        "C Z" -> 6
        _ -> 0

parseLine2 = \lineStr ->
    when lineStr is
        "A X" -> 3
        "A Y" -> 4
        "A Z" -> 8
        "B X" -> 1
        "B Y" -> 5
        "B Z" -> 9
        "C X" -> 2
        "C Y" -> 6
        "C Z" -> 7
        _ -> 0




