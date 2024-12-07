import gleam/int
import gleam/list
import gleam/pair
import gleam/regexp
import gleam/string
import parse_helper

fn extract(match: regexp.Match) {
  match.content
  |> string.drop_start(4)
  |> string.drop_end(1)
  |> string.split(",")
  |> parse_helper.to_int_pair()
}

fn parse(line: String) {
  let regex = case regexp.from_string("mul\\(\\d+,\\d+\\)") {
    Ok(regex) -> regex
    Error(_) -> panic as "regex error!"
  }

  regexp.scan(regex, line)
  |> list.map(extract)
}

pub fn a(input: List(String)) {
  input
  |> list.map(parse)
  |> list.flat_map(fn(l) {
    list.map(l, fn(p) { pair.first(p) * pair.second(p) })
  })
  |> int.sum
}

fn parse_b(line: String) {
  let regex = case regexp.from_string("don't\\(\\).*?do\\(\\)") {
    Ok(regex) -> regex
    Error(_) -> panic as "regex error!"
  }

  regexp.replace(regex, line, "")
  |> parse
}

pub fn b(input: List(String)) {
  input
  |> list.map(fn(line) { line <> "do()" })
  |> list.map(parse_b)
  |> list.flat_map(fn(l) {
    list.map(l, fn(p) { pair.first(p) * pair.second(p) })
  })
  |> int.sum
}
