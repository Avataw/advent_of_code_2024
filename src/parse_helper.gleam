import gleam/dict
import gleam/int
import gleam/list
import gleam/pair
import gleam/string
import position_helper

pub fn to_int(s: String) {
  case int.parse(s) {
    Ok(i) -> i
    _ -> panic as "String could not be parsed as int"
  }
}

pub fn to_int_pair(line: List(String)) {
  let nums =
    line
    |> list.map(to_int)

  case nums {
    [a, b] -> pair.new(a, b)
    [] | [_] | _ -> panic as "Parsing Error"
  }
}

pub fn parse_grid(input: List(String)) {
  input
  |> list.index_map(fn(line, y) {
    string.split(line, "")
    |> list.index_map(fn(char, x) {
      pair.new(position_helper.Position(x, y), char)
    })
  })
  |> list.flatten
  |> list.fold(dict.new(), fn(acc, cur) {
    dict.insert(acc, pair.first(cur), pair.second(cur))
  })
}
