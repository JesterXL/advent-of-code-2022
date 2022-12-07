app "AoC Day 5 - Pick 'Em Up, Put 'Em Dowwwwnn"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [
        pf.Stdout, 
        pf.Path, 
        pf.File, 
        pf.Task, 
        Crates
    ]
    provides [main] to pf

main =
    task =
        inputStr <- Path.fromStr "input_small.txt" |> File.readUtf8 |> Task.await
        part1Answer = part1 inputStr
        dbg part1Answer
            # moves: [{ amount: 2, from: 2, to: 1 }, { amount: 1, from: 1, to: 2 }, { amount: 1, from: 0, to: 204 }, { amount: 0, from: 0, to: 0 }], 
            # stack: @Dict [Pair 1 [], Pair 2 [], Pair 3 []] }
        Stdout.write "Part 1:"
    Task.onFail task \_ -> crash "Failed to read and parse input"

part1 = \str ->
    # moves =
    #     Str.split str " \n\n"
    #     |> List.last
    #     |> Result.withDefault ""
    #     |> Str.split "\n"
    #     |> List.map \moveStr -> Str.split moveStr " "
    #     |> List.map \moveStrList -> # I have to have the thingStr below, else I get Str.toNat failing randomly, it's nuts!
    #         {
    #             amount: List.get moveStrList 1 |> Result.withDefault "-1" |> Str.toNat |> Result.withDefault 0,
    #             amountStr: List.get moveStrList 1 |> Result.withDefault "-1",
    #             from: List.get moveStrList 3 |> Result.withDefault "-1" |> Str.toNat |> Result.withDefault 0 |> Num.sub 1,
    #             fromStr: List.get moveStrList 3 |> Result.withDefault "-1",
    #             to: List.get moveStrList 5 |> Result.withDefault "-1" |> Str.toNat |> Result.withDefault 0 |> Num.sub 1,
    #             toStr: List.get moveStrList 5 |> Result.withDefault "-1"
    #         }

    stackTotal =
        Str.split str " \n\n"
        |> List.first
        |> Result.withDefault ""
        |> Str.split "\n"
        |> List.first
        |> Result.withDefault ""
        |> Str.countUtf8Bytes
        |> Num.add 1
        |> Num.toFrac
        |> Num.div 4

    crates =
        Str.split str " \n\n"
        |> List.first
        |> Result.withDefault ""
        |> Str.split "\n"
        |> List.dropLast
        |> List.map \elem ->
            when stackTotal is
                3 -> [parseCrateAt elem 1, parseCrateAt elem 5, parseCrateAt elem 9]
                9 -> [parseCrateAt elem 1, parseCrateAt elem 5, parseCrateAt elem 9, parseCrateAt elem 13, parseCrateAt elem 17, parseCrateAt elem 21, parseCrateAt elem 25, parseCrateAt elem 29, parseCrateAt elem 33]
                _ -> []

    # datLen = List.first crates |> Result.withDefault [] |> List.len |> Num.toU32

    
    
    stuff = List.walk crates Dict.empty \state, elem ->
            # { state & index: state.index, stack: List.walk elem Dict.empty \_, crate ->
            #     Crates.addCrate state.stack state.index crate }
            addCrates elem state
    
    stuff

addCrates : List Str, Dict U32 (List Str) -> Dict U32 (List Str)
addCrates = \listOfCrates, stack ->
    List.walk listOfCrates { index: 0, stack: stack } addCrateIndex
    |> .stack
        

addCrateIndex : { index: U32, stack: Dict U32 (List Str) }, Str -> { index: U32, stack: Dict U32 (List Str) }
addCrateIndex = \state, crate ->
    updatedStack = Crates.addCrate state.stack state.index crate
    { index: state.index + 1, stack: updatedStack }

parseCrateAt : Str, Nat -> Str
parseCrateAt = \str, index ->
    str |> Str.toUtf8 |> List.get index |> Result.withDefault 0 |> List.single |> Str.fromUtf8 |> Result.withDefault ""


# # moveCrate = \stack, move ->
# #     crates = getCrates stack move.from
# #     topCrate = lastCrate crates
# #     removed = List.dropLast crates
# #     addCrate stack move.to topCrate |> Dict.insert move.to removed




# # lastCrate : List Str -> Str
# # lastCrate = \list ->
# #     List.last list |> Result.withDefault " "



# # addCrate = \dict, index, crate ->
# #     crates = getCrates dict index
# #     updated = List.append crates crate
# #     Dict.insert dict index updated



