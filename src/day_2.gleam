import gleam/bool
import gleam/list
import gleam/pair
import gleam/string
import parse_helper

fn parse(input: String) {
  input |> string.split(" ") |> list.map(parse_helper.to_int)
}

fn valid(levels: List(Int), with_damper: Bool) {
  validate_ascending(levels, with_damper)
  || validate_descending(levels, with_damper)
}

fn validate_ascending(levels: List(Int), with_damper: Bool) {
  let bad_level =
    levels
    |> list.index_map(fn(value, index) { pair.new(value, index) })
    |> list.window_by_2()
    |> list.find(fn(p) {
      bool.negate(
        pair.first(pair.second(p)) == pair.first(pair.first(p)) + 1
        || pair.first(pair.second(p)) == pair.first(pair.first(p)) + 2
        || pair.first(pair.second(p)) == pair.first(pair.first(p)) + 3,
      )
    })

  case bad_level {
    Ok(bad_pair) if with_damper ->
      valid(levels |> remove_n(pair.second(pair.first(bad_pair))), False)
      || valid(levels |> remove_n(pair.second(pair.second(bad_pair))), False)
    Error(_) -> True
    _ -> False
  }
}

fn validate_descending(levels: List(Int), with_damper: Bool) {
  let bad_level =
    levels
    |> list.index_map(fn(value, index) { pair.new(value, index) })
    |> list.window_by_2()
    |> list.find(fn(p) {
      bool.negate(
        pair.first(pair.second(p)) == pair.first(pair.first(p)) - 1
        || pair.first(pair.second(p)) == pair.first(pair.first(p)) - 2
        || pair.first(pair.second(p)) == pair.first(pair.first(p)) - 3,
      )
    })

  case bad_level {
    Ok(bad_pair) if with_damper ->
      valid(levels |> remove_n(pair.second(pair.first(bad_pair))), False)
      || valid(levels |> remove_n(pair.second(pair.second(bad_pair))), False)
    Error(_) -> True
    _ -> False
  }
}

fn remove_n(list: List(Int), index: Int) {
  case
    list
    |> list.index_map(fn(value, index) { pair.new(value, index) })
    |> list.pop(fn(value) { pair.second(value) == index })
  {
    Ok(list) -> pair.second(list) |> list.map(fn(value) { pair.first(value) })
    Error(_) -> panic as "Something must have gone incredibly wrong"
  }
}

pub fn a(input: List(String)) {
  input |> list.map(parse) |> list.count(fn(level) { valid(level, False) })
}

pub fn b(input: List(String)) {
  input |> list.map(parse) |> list.count(fn(level) { valid(level, True) })
}
