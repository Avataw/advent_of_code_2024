import gleam/dict
import gleam/int
import gleam/list
import gleam/pair
import gleam/string
import parse_helper

fn get_orders(lines: List(String)) {
  lines
  |> list.map(fn(line) { line |> string.split("|") |> parse_helper.to_int_pair })
  |> list.fold(dict.new(), fn(acc, cur) {
    let new_value = case dict.get(acc, pair.first(cur)) {
      Ok(prev) -> [pair.second(cur), ..prev]
      Error(_) -> [pair.second(cur)]
    }

    dict.insert(acc, pair.first(cur), new_value)
  })
}

fn get_middle(list: List(Int)) {
  let middle = list.length(list) / 2

  case
    list
    |> list.index_map(fn(value, index) { pair.new(index, value) })
    |> list.drop_while(fn(p) { pair.first(p) < middle })
    |> list.first()
  {
    Ok(p) -> pair.second(p)
    Error(_) -> panic as "has no middle?"
  }
}

fn validate(updates: List(Int), orders: dict.Dict(Int, List(Int))) {
  updates
  |> list.fold_until([], fn(acc, cur) {
    let is_valid = case dict.get(orders, cur) {
      Ok(value) ->
        acc |> list.all(fn(prev) { list.contains(value, prev) == False })
      Error(_) -> True
    }
    case is_valid {
      True -> list.Continue([cur, ..acc])
      False -> list.Stop([])
    }
  })
  |> list.is_empty
  == False
}

fn parse_orders(input: List(String)) {
  input
  |> list.take_while(fn(line) { line != "" })
}

fn parse_updates(input: List(String)) {
  input
  |> list.drop_while(fn(line) { line != "" })
  |> list.drop(1)
  |> list.map(fn(line) {
    line |> string.split(",") |> list.map(parse_helper.to_int)
  })
}

pub fn a(input: List(String)) {
  let orders =
    input
    |> parse_orders
    |> get_orders

  input
  |> parse_updates
  |> list.filter(fn(updates) { updates |> validate(orders) })
  |> list.map(get_middle)
  |> int.sum
}

fn fix(updates: List(Int), orders: dict.Dict(Int, List(Int))) {
  updates
  |> list.fold([], fn(acc, _) {
    let left =
      updates
      |> list.filter(fn(update) { list.contains(acc, update) == False })

    let next =
      left
      |> list.filter(fn(update) {
        case dict.get(orders, update) {
          Error(_) -> True
          Ok(prevs) ->
            list.all(prevs, fn(prev) { list.contains(left, prev) == False })
        }
      })
      |> list.first

    case next {
      Ok(next) -> [next, ..acc]
      Error(_) -> panic as "this should not happen!"
    }
  })
}

pub fn b(input: List(String)) {
  let orders =
    input
    |> parse_orders
    |> get_orders

  input
  |> parse_updates
  |> list.filter(fn(updates) { updates |> validate(orders) == False })
  |> list.map(fn(updates) { updates |> fix(orders) })
  |> list.map(get_middle)
  |> int.sum
}
