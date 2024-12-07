import gleam/int
import gleam/list
import gleam/pair
import gleam/string
import parse_helper

fn to_int_pair(line: String) {
  let nums =
    line
    |> string.split("   ")
    |> list.map(parse_helper.to_int)

  case nums {
    [a, b] -> pair.new(a, b)
    [] | [_] | _ -> panic as "Parsing Error"
  }
}

pub fn a(input: List(String)) {
  let pairs =
    input
    |> list.map(to_int_pair)

  let firsts =
    pairs
    |> list.map(fn(p) { pair.first(p) })
    |> list.sort(by: int.compare)

  let seconds =
    pairs
    |> list.map(fn(p) { pair.second(p) })
    |> list.sort(by: int.compare)

  list.zip(firsts, seconds)
  |> list.map(fn(p) { int.absolute_value(pair.first(p) - pair.second(p)) })
  |> int.sum()
}

pub fn b(input: List(String)) {
  let pairs =
    input
    |> list.map(to_int_pair)

  let firsts =
    pairs
    |> list.map(fn(p) { pair.first(p) })
    |> list.sort(by: int.compare)

  let seconds =
    pairs
    |> list.map(fn(p) { pair.second(p) })

  firsts
  |> list.map(fn(num) { num * list.count(seconds, fn(s) { s == num }) })
  |> int.sum()
}
