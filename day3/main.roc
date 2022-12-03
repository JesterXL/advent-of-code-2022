app "AoC Day 3 - Bring Da Ruckus! WHO QWAN TEST!?"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Path, pf.File, pf.Task]
    provides [main] to pf

# Part 1
# Attempt 1 - 7701, CORRECT! First try baby.:: Ben Stiller voice :: "Again. Again."

# priorities = { a:1,  b:2,  c:3,  d:4,  e:5,  f:6,  g:7,  h:8,  i:9,  j:10, k:11, l:12, m:13, n:14, o:15, p:16, q:17, r:18, s:19, t:20, u:21, v:22, w:23, x:24, y:25, z:26,
#                A:27, B:28, C:29, D:30, E:31, F:32, G:33, H:34, I:35, J:36, K:37, L:38, M:39, N:40, O:41, P:42, Q:43, R:44, S:45, T:46, U:47, V:48, W:49, X:50, Y:51, Z:52 }
main =
    task =
        inputStr <- Path.fromStr "input.txt" |> File.readUtf8 |> Task.await
        lines = Str.split inputStr "\n" |> List.map sackify |> List.map utfToPriority |> List.map Num.toU32 |> List.sum
        # |> List.map getPriority
            # |> List.mapTry Str.fromUtf8 |> Result.withDefault []
            # |> List.map getPriority |> List.sum
        dbg lines
        Stdout.write "Part 1: "
    Task.onFail task \_ -> crash "Failed to read and parse input"

sackify = \chars ->
    list = Str.toUtf8 chars
    { before, others } = list |> List.split (List.len list // 2)
    Set.intersection (Set.fromList before) (Set.fromList others) |> Set.toList |> List.get 0 |> Result.withDefault 0

# getPriority = \utf ->
#     datNat = Num.toNat utf
#     priority = utfToPriority datNat
#     str = Str.fromUtf8 [utf] |> Result.withDefault "???"
#     { utf: utf, priority: priority, str: str }
    
utfToPriority = \utf ->
    if utf >= 97 && utf <= 122 then
        utf - 96
    else if utf >= 65 && utf <= 90 then
        utf - 38
    else
        0


