interface Crates
    exposes [
        getCrateAt,
        getCrates,
        addCrate,
        moveCrate
    ]
    imports []

# NOTE: Cannot use Nat for keys right now, lelz, a bug
getCrateAt : Dict U32 (List Str), U32, Nat -> Str
getCrateAt = \stack, stackIndex, index ->
    Dict.get stack stackIndex |> Result.withDefault [] |> List.get index |> Result.withDefault " "

getCrates : Dict U32 (List Str), U32 -> List Str
getCrates = \stack, index ->
    Dict.get stack index |> Result.withDefault []

addCrate : Dict U32 (List Str), U32, Str -> Dict U32 (List Str)
addCrate = \stack, index, crate ->
    updatedCrates =
        Dict.get stack index |> Result.withDefault [] |> List.append crate
    Dict.insert stack index updatedCrates

Move : {
    amount : U32,
    from : U32,
    to : U32
}

moveCrate : Dict U32 (List Str), Move -> Dict U32 (List Str)
moveCrate = \stack, move ->
    crates = getCrates stack move.from
    topCrate = List.last crates |> Result.withDefault " "
    removed = List.dropLast crates
    addCrate stack move.to topCrate |> Dict.insert move.from removed 

cratesFixture =
    Dict.empty |> Dict.insert 0 ["A"]

cratesFixtureB =
    Dict.empty |> Dict.insert 0 ["B"]

expect (getCrateAt cratesFixture 0 0) == "A"
expect (getCrateAt cratesFixture 0 1) == " "
expect (getCrateAt cratesFixture 1 0) == " "

expect (getCrates cratesFixture 0) == ["A"]
expect (getCrates cratesFixtureB 0) == ["B"]
expect (getCrates cratesFixture 1) == []

cratesFixtureC =
    Dict.empty |> Dict.insert 1 ["B"]

cratesBlankFixture =
    Dict.empty

samplePuzzleFixture =
    Dict.empty
    |> Dict.insert 0 ["Z", "N"]
    |> Dict.insert 1 ["M", "C", "D"]
    |> Dict.insert 2 ["P"]

expect (addCrate cratesFixture 1 "B" |> getCrateAt 1 0) == "B"
expect (addCrate cratesFixtureC 0 "A" |> getCrateAt 0 0) == "A"
expect (addCrate cratesBlankFixture 1 "A" |> getCrateAt 1 0) == "A"
expect (addCrate samplePuzzleFixture 0 "D" |> getCrates 0) == ["Z", "N", "D"]

expect (moveCrate cratesFixture { amount: 1, from: 0, to: 1 } |> getCrateAt 1 0) == "A"
expect (moveCrate samplePuzzleFixture { amount: 1, from: 0, to: 1 } |> getCrateAt 1 3) == "N"

