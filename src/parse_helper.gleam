import gleam/int
import gleam/list
import gleam/pair

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
