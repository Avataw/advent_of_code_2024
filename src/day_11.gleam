import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import parse_helper

fn is_zero(str: String) {
  str |> string.to_graphemes |> list.all(fn(c) { c == "0" })
}

fn half(str: String, len: Int) {
  let mid = len / 2

  let first_half = string.slice(str, 0, mid)

  let second_slice = string.slice(str, mid, len - mid)

  let second_half = case second_slice |> is_zero {
    True -> "0"
    False ->
      second_slice
      |> string.to_graphemes
      |> list.drop_while(fn(char) { char == "0" })
      |> string.join("")
  }

  [first_half, second_half]
}

fn replace(str: String) {
  str
  |> parse_helper.to_int
  |> int.multiply(2024)
  |> int.to_string
  |> list.wrap
}

fn solve(nums: List(String)) {
  nums
  |> list.flat_map(fn(num) {
    let is_zero = num |> is_zero

    case is_zero {
      True -> ["1"]
      False -> {
        let length = string.length(num)
        case length % 2 == 0 {
          True -> half(num, length)
          False -> replace(num)
        }
      }
    }
  })
}

fn parse(input: List(String)) {
  input
  |> list.first
  |> result.unwrap("")
  |> string.split(" ")
}

pub fn a(input: List(String)) {
  list.repeat(0, 25)
  |> list.fold(parse(input), fn(acc, _) { solve(acc) })
  |> list.length
}

fn solve_b(str: String) {
  let is_zero = str |> is_zero

  case is_zero {
    True -> ["1"]
    False -> {
      let length = string.length(str)
      case length % 2 == 0 {
        True -> half(str, length)
        False -> replace(str)
      }
    }
  }
}

pub fn b(input: List(String)) {
  let dict =
    input
    |> parse
    |> list.fold(dict.new(), fn(acc, cur) { acc |> dict.insert(cur, 1) })

  list.repeat(0, 75)
  |> list.fold(dict, fn(acc, _) {
    acc
    |> dict.to_list
    |> list.fold(dict.new(), fn(inner_acc, inner_cur) {
      let #(key, value) = inner_cur

      solve_b(key)
      |> list.fold(inner_acc, fn(inner_acc, result) {
        inner_acc
        |> dict.upsert(result, fn(v) {
          case v {
            option.None -> value
            option.Some(prev) -> prev + value
          }
        })
      })
    })
  })
  |> dict.values
  |> int.sum
}
