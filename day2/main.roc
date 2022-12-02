app "AoC Day 2 - Rock Paper Scissors"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

# Part 1
# Attempt 1 - 10310, CORRECT! First try, baby. Again.

# saysYeah = \yup ->
#     "\(yup) yeah!"

# expect saysYeah "cactus" == "cactus yeah!"

main =
    task =
        inputStr <- Path.fromStr "input.txt" |> File.readUtf8 |> Task.await
        totalScore = parse inputStr
        # dbg totalScore
        Stdout.write "Part 1: \(totalScore)\n"

    Task.onFail task \_ -> crash "Failed to read and parse input"

parse = \inputStr ->
    Str.split inputStr "\n"
    |> List.map parseLine
    # |> List.dropIf isUnknownStrategy
    # |> List.sum
    |> sumScore
    |> Num.toStr

parseLine = \lineStr ->
    when lineStr is
        "A X" -> RockVsRockDraw (1 + 3)
        "A Y" -> RockVsPaperWin (2 + 6)
        "A Z" -> RockVsScissorsLoss (3 + 0)
        "B X" -> PaperVsRockLoss (1 + 0)
        "B Y" -> PaperVsPaperDraw (2 + 3)
        "B Z" -> PaperVsScissorsWin (3 + 6)
        "C X" -> ScissorsVsRockWin (1 + 6)
        "C Y" -> ScissorsVsPaperLoss (2 + 0)
        "C Z" -> ScissorsVsScissorsDraw (3 + 3)
        x -> UnknownStrategy "C-C-C-Combo breaker! Unknown move: \(x)" 

# isUnknownStrategy = \gameTag ->
#     when gameTag is
#         UnknownStrategy _ -> true
#         _ -> false

sumScore = \rounds ->
    List.walk rounds 0 \state, elem ->
        when elem is
            UnknownStrategy _ -> state
            RockVsRockDraw score -> state + score
            RockVsPaperWin score -> state + score
            RockVsScissorsLoss score -> state + score
            PaperVsRockLoss score -> state + score
            PaperVsPaperDraw score -> state + score
            PaperVsScissorsWin score -> state + score
            ScissorsVsRockWin score -> state + score
            ScissorsVsPaperLoss score -> state + score
            ScissorsVsScissorsDraw score -> state + score



