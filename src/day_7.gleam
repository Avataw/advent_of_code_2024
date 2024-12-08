import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string

fn parse_result(input: String) {
  input
  |> string.split(": ")
  |> list.first
  |> result.unwrap("")
  |> int.parse()
  |> result.unwrap(-1)
}

fn parse_components(input: String) {
  input
  |> string.split(": ")
  |> list.drop(1)
  |> list.first
  |> result.unwrap("")
  |> string.split(" ")
  |> list.map(fn(val) { val |> int.parse |> result.unwrap(-1) })
}

fn parse(input: List(String)) {
  input
  |> list.map(fn(line) {
    let result = parse_result(line)
    let components = parse_components(line)
    #(result, components)
  })
}

fn validate(input: #(Int, List(Int))) {
  let #(result, components) = input

  components
  |> list.fold([], fn(acc, cur) {
    case acc {
      [] -> [cur]
      _ -> {
        acc
        |> list.flat_map(fn(prev_result) {
          [prev_result * cur, prev_result + cur]
        })
      }
    }
  })
  |> list.any(fn(res) { result == res })
}

pub fn a(input: List(String)) {
  input
  |> parse
  |> list.filter(validate)
  |> list.map(pair.first)
  |> int.sum
}

fn concat(a: Int, b: Int) {
  int.parse(int.to_string(a) <> int.to_string(b)) |> result.unwrap(-1)
}

fn validate_b(input: #(Int, List(Int))) {
  let #(result, components) = input

  components
  |> list.fold([], fn(acc, cur) {
    case acc {
      [] -> [cur]
      _ -> {
        acc
        |> list.flat_map(fn(prev_result) {
          let concatted = concat(prev_result, cur)

          case concatted {
            concatted if concatted > result -> [
              prev_result * cur,
              prev_result + cur,
            ]
            _ -> [prev_result * cur, prev_result + cur, concatted]
          }
        })
      }
    }
  })
  |> list.any(fn(res) { result == res })
}

pub fn b(input: List(String)) {
  input
  |> parse
  |> list.filter(validate_b)
  |> list.map(pair.first)
  |> int.sum
}
