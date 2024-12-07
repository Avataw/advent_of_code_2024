import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/pair
import gleam/regexp
import gleam/string
import position_helper

fn new_regexp(pattern: String) {
  case regexp.from_string(pattern) {
    Ok(regex) -> regex
    Error(_) -> panic as "regex error!"
  }
}

fn find_occurences(line: String) {
  let xmas =
    new_regexp("XMAS")
    |> regexp.scan(line)
    |> list.length

  let samx =
    new_regexp("SAMX")
    |> regexp.scan(line)
    |> list.length

  xmas + samx
}

fn count_horizontal(lines: List(String)) {
  lines |> list.map(find_occurences)
}

fn count_vertical(lines: List(String)) {
  lines
  |> list.index_map(fn(line, y) {
    list.index_map(string.split(line, ""), fn(char, x) {
      pair.new(char, position_helper.Position(x, y))
    })
  })
  |> list.flatten
  |> list.group(fn(value) { pair.second(value).x })
  |> dict.values
  |> list.map(fn(values) {
    list.map(values, fn(value) { pair.first(value) }) |> string.join("")
  })
  |> list.map(find_occurences)
}

fn count_diagonal(lines: List(String)) {
  let x_max = head(lines) |> string.length

  let by_position =
    lines
    |> list.index_map(fn(line, y) {
      list.index_map(string.split(line, ""), fn(char, x) {
        pair.new(char, position_helper.Position(x, y))
      })
    })
    |> list.flatten
    |> list.group(fn(value) { pair.second(value) })

  let diagonal_right_occs =
    by_position
    |> dict.keys
    |> list.filter(fn(pos) { pos.x == 0 || pos.y == 0 })
    |> list.map(fn(start_pos) {
      traverse_down_right(by_position, start_pos, []) |> string.join("")
    })
    |> list.map(find_occurences)
    |> int.sum

  let diagonal_left_occs =
    by_position
    |> dict.keys
    |> list.filter(fn(pos) { pos.x == x_max - 1 || pos.y == 0 })
    |> list.map(fn(start_pos) {
      traverse_down_left(by_position, start_pos, []) |> string.join("")
    })
    |> list.map(find_occurences)
    |> int.sum

  diagonal_left_occs + diagonal_right_occs
}

fn traverse_down_left(
  dict: dict.Dict(
    position_helper.Position,
    List(#(String, position_helper.Position)),
  ),
  position: position_helper.Position,
  diagonal: List(String),
) {
  case dict.get(dict, position) {
    Ok(p) ->
      traverse_down_left(dict, position_helper.down_left(position), [
        head(p) |> pair.first(),
        ..diagonal
      ])
    Error(_) -> diagonal
  }
}

fn traverse_down_right(
  dict: dict.Dict(
    position_helper.Position,
    List(#(String, position_helper.Position)),
  ),
  position: position_helper.Position,
  diagonal: List(String),
) {
  case dict.get(dict, position) {
    Ok(p) ->
      traverse_down_right(dict, position_helper.down_right(position), [
        head(p) |> pair.first(),
        ..diagonal
      ])
    Error(_) -> diagonal
  }
}

fn head(list) {
  case list.first(list) {
    Ok(value) -> value
    Error(_) -> panic as "list is empty!"
  }
}

fn count(lines: List(String)) {
  let vertical = count_vertical(lines) |> int.sum()
  let horizontal = count_horizontal(lines) |> int.sum()
  let diagonal = count_diagonal(lines)
  vertical + horizontal + diagonal
}

pub fn a(input: List(String)) {
  input |> count
}

fn to_dict(lines: List(String)) {
  lines
  |> list.index_map(fn(line, y) {
    list.index_map(string.split(line, ""), fn(char, x) {
      pair.new(char, position_helper.Position(x, y))
    })
  })
  |> list.flatten
  |> list.group(fn(value) { pair.second(value) })
}

fn count_xmas(lines: List(String)) {
  let x_max = head(lines) |> string.length
  let y_max = lines |> list.length

  let by_position = to_dict(lines)

  by_position
  |> dict.values()
  |> list.flatten
  |> list.filter(fn(value) {
    pair.second(value).x > 0
    && pair.second(value).x < x_max - 1
    && pair.second(value).y > 0
    && pair.second(value).y < y_max - 1
  })
  |> list.count(fn(value) { is_xmas(by_position, pair.second(value)) })
}

fn is_xmas(
  dict: dict.Dict(
    position_helper.Position,
    List(#(String, position_helper.Position)),
  ),
  position: position_helper.Position,
) {
  bool.and(
    bool.or(
      {
        position_helper.up_left(position) |> check_in_dict(dict, "M")
        && position |> check_in_dict(dict, "A")
        && position_helper.down_right(position) |> check_in_dict(dict, "S")
      },
      {
        position_helper.up_left(position) |> check_in_dict(dict, "S")
        && position |> check_in_dict(dict, "A")
        && position_helper.down_right(position) |> check_in_dict(dict, "M")
      },
    ),
    bool.or(
      {
        position_helper.up_right(position) |> check_in_dict(dict, "M")
        && position |> check_in_dict(dict, "A")
        && position_helper.down_left(position) |> check_in_dict(dict, "S")
      },
      {
        position_helper.up_right(position) |> check_in_dict(dict, "S")
        && position |> check_in_dict(dict, "A")
        && position_helper.down_left(position) |> check_in_dict(dict, "M")
      },
    ),
  )
}

fn check_in_dict(
  position: position_helper.Position,
  dict: dict.Dict(
    position_helper.Position,
    List(#(String, position_helper.Position)),
  ),
  value: String,
) {
  case dict.get(dict, position) {
    Ok(val) -> val |> head |> pair.first == value
    Error(_) -> False
  }
}

pub fn b(input: List(String)) {
  input |> count_xmas
}
