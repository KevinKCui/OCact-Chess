open OUnit2
open Chess
open Command
open State

(** tests *)
let state_tests = []

let parse_test (name : string) (input : string) (expected_output : string) =
  name >:: fun _ ->
  assert_equal expected_output (get_command (parse input)) ~printer:Fun.id

let parse_test_invalid (name : string) (input : string) =
  name >:: fun _ -> assert_raises MalformedInput (fun () -> parse input)

let pawn_tests (name : string) (board_state : board_state) =
  name >:: fun _ ->
  let pawn_pos = moves_pawn_single board_state false in
  let combined =
    List.fold_right Int64.logor (List.map snd pawn_pos) Int64.zero
  in
  let _ = Printf.printf "print_start\n%s\n" (Int64.to_string combined) in
  assert_equal true true

let command_tests =
  [ (* parse_test "basic input" "a3 a4" "a3 a4"; parse_test "uppercase both" "B3
       C6" "b3 c6"; parse_test "uppercase one" "g8 F6" "g8 f6"; parse_test
       "extreme bounds" "a1 h8" "a1 h8"; parse_test_invalid "out of bounds
       invalid" "a0 c1"; parse_test_invalid "bad spacing" "a3 a4";
       parse_test_invalid "no spaces" "a3a4"; parse_test_invalid "same square"
       "c1 c1"; parse_test_invalid "random" "asdflk214p9u124 1249u09v"; *) ]

let command_tests = [
  parse_test "basic input" "a3 a4" "a3 a4";
  parse_test "uppercase both" "B3 C6" "b3 c6"; 
  parse_test "uppercase one" "g8 F6" "g8 f6"; 
  parse_test "extreme bounds" "a1 h8" "a1 h8"; 
  parse_test_invalid "out of bounds invalid" "a0 c1"; 
  parse_test_invalid "bad spacing" "a3   a4"; 
  parse_test_invalid "no spaces" "a3a4"; 
  parse_test_invalid "same square" "c1 c1";
  parse_test_invalid "random" "asdflk214p9u124 1249u09v";
]

let rec board_printer board_list = match board_list with
| [] -> ()
| (_,a,b) :: t -> let _ = print_board b in 
let _ = print_endline(Int64.to_string (get_val b)) in
board_printer t

let _ = print_endline "TEST PAWNS"
let _ = board_printer(pseudolegal_moves_pawns (init_chess))

let new_board = move init_chess (parse "e2 e4")
let new_board1 = move new_board (parse "e7 e5")
let _ = board_printer(pseudolegal_moves_pawns (new_board1))
let state_tests = []
let piece_tests = [ pawn_tests "test" init_chess ]
let gui_tests = []

let suite =
  "test suite for A2"
  >::: List.flatten [ state_tests; command_tests; state_tests; gui_tests ]

let _ = run_test_tt_main suite
