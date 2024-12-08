import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import position_helper

fn to_grid(input: List(String)) {
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

fn get_start_position(grid: dict.Dict(position_helper.Position, String)) {
  case
    grid
    |> dict.filter(fn(pos, char) { char == "^" })
    |> dict.to_list
    |> list.first()
  {
    Error(_) -> panic as "Start not found"
    Ok(entry) -> entry |> pair.first()
  }
}

fn up(
  grid: dict.Dict(position_helper.Position, String),
  position: position_helper.Position,
) {
  grid
  |> dict.filter(fn(pos, char) {
    pos.y < position.y && pos.x == position.x && char == "#"
  })
  |> dict.to_list
  |> list.sort(fn(a, b) {
    int.compare(pair.first(b).y - position.y, pair.first(a).y - position.y)
  })
  |> list.first
}

fn down(
  grid: dict.Dict(position_helper.Position, String),
  position: position_helper.Position,
) {
  grid
  |> dict.filter(fn(pos, char) {
    pos.y > position.y && pos.x == position.x && char == "#"
  })
  |> dict.to_list
  |> list.sort(fn(a, b) {
    int.compare(pair.first(a).y - position.y, pair.first(b).y - position.y)
  })
  |> list.first
}

fn right(
  grid: dict.Dict(position_helper.Position, String),
  position: position_helper.Position,
) {
  grid
  |> dict.filter(fn(pos, char) {
    pos.y == position.y && pos.x > position.x && char == "#"
  })
  |> dict.to_list
  |> list.sort(fn(a, b) {
    int.compare(pair.first(a).x - position.x, pair.first(b).x - position.x)
  })
  |> list.first
}

fn left(
  grid: dict.Dict(position_helper.Position, String),
  position: position_helper.Position,
) {
  grid
  |> dict.filter(fn(pos, char) {
    pos.y == position.y && pos.x < position.x && char == "#"
  })
  |> dict.to_list
  |> list.sort(fn(a, b) {
    int.compare(pair.first(b).x - position.x, pair.first(a).x - position.x)
  })
  |> list.first
}

fn traverse(
  grid: dict.Dict(position_helper.Position, String),
  traversed: List(#(position_helper.Position, position_helper.Position, String)),
  position: position_helper.Position,
  direction: String,
  max_x: Int,
  max_y: Int,
) {
  let step = case direction {
    "UP" -> up(grid, position)
    "DOWN" -> down(grid, position)
    "RIGHT" -> right(grid, position)
    "LEFT" -> left(grid, position)
    _ -> panic as "Invalid direction"
  }

  case step {
    Ok(end) -> {
      let end_position = end |> pair.first

      let next_position = case direction {
        "UP" -> end_position |> position_helper.down
        "DOWN" -> end_position |> position_helper.up
        "RIGHT" -> end_position |> position_helper.left
        "LEFT" -> end_position |> position_helper.right
        _ -> panic as "Invalid direction"
      }

      let next_direction = case direction {
        "UP" -> "RIGHT"
        "RIGHT" -> "DOWN"
        "DOWN" -> "LEFT"
        "LEFT" -> "UP"
        _ -> panic as "Invalid direction"
      }

      let next_traversed = [#(position, end_position, direction), ..traversed]

      traverse(
        grid,
        next_traversed,
        next_position,
        next_direction,
        max_x,
        max_y,
      )
    }
    Error(_) -> {
      let end_position = case direction {
        "UP" -> position_helper.Position(position.x, 0)
        "RIGHT" -> position_helper.Position(max_x, position.y)
        "DOWN" -> position_helper.Position(position.x, max_y)
        "LEFT" -> position_helper.Position(0, position.y)
        _ -> panic as "Invalid direction"
      }

      [#(position, end_position, direction), ..traversed]
    }
  }
}

fn build_traversed(
  ranges: List(#(position_helper.Position, position_helper.Position, String)),
) {
  ranges
  |> list.map(fn(cur) {
    let #(start, end, _) = cur

    let start_x = int.min(start.x, end.x)
    let start_y = int.min(start.y, end.y)
    let end_x = int.max(start.x, end.x)
    let end_y = int.max(start.y, end.y)

    case start_x == end_x {
      True ->
        list.range(start_y + 1, end_y - 1)
        |> list.map(fn(y) { int.to_string(start_x) <> "," <> int.to_string(y) })
      False ->
        list.range(start_x + 1, end_x - 1)
        |> list.map(fn(x) { int.to_string(x) <> "," <> int.to_string(start_y) })
    }
  })
  |> list.flatten
  |> list.unique
}

fn calc_total_distance(
  ranges: List(#(position_helper.Position, position_helper.Position, String)),
) {
  ranges
  |> build_traversed
  |> list.length
  // start_position wasn't counted yet
  |> int.add(1)
}

pub fn a(input: List(String)) {
  let max_x = input |> list.first() |> result.unwrap("") |> string.length
  let max_y = input |> list.length
  let grid = to_grid(input)

  let start_position = get_start_position(grid)
  traverse(grid, [], start_position, "UP", max_x - 1, max_y - 1)
  |> calc_total_distance
}

fn build_traversed_b(
  ranges: List(#(position_helper.Position, position_helper.Position, String)),
) {
  let traversed =
    ranges
    |> list.fold(dict.new(), fn(acc, cur) {
      let #(start, end, dir) = cur

      let range = case dir {
        "UP" -> list.range(start.y, end.y + 1)
        "RIGHT" -> list.range(start.x, end.x - 1)
        "DOWN" -> list.range(start.y, end.y - 1)
        "LEFT" -> list.range(start.x, end.x + 1)
        _ -> panic("Invalid Direction")
      }

      case start.x == end.x {
        True ->
          range
          |> list.fold(acc, fn(acc_inner, y) {
            case dict.get(acc_inner, position_helper.Position(start.x, y)) {
              Error(_) ->
                dict.insert(acc_inner, position_helper.Position(start.x, y), [
                  dir,
                ])
              Ok(existing_dirs) ->
                dict.insert(acc_inner, position_helper.Position(start.x, y), [
                  dir,
                  ..existing_dirs
                ])
            }
          })
        False ->
          range
          |> list.fold(acc, fn(acc_inner, x) {
            case dict.get(acc_inner, position_helper.Position(x, start.y)) {
              Error(_) ->
                dict.insert(acc_inner, position_helper.Position(x, start.y), [
                  dir,
                ])
              Ok(existing_dirs) ->
                dict.insert(acc_inner, position_helper.Position(x, start.y), [
                  dir,
                  ..existing_dirs
                ])
            }
          })
      }
    })

  traversed
  |> io.debug
  |> dict.filter(fn(pos, dirs) {
    dirs
    |> list.any(fn(dir) {
      case dir {
        "UP" ->
          dict.get(traversed, position_helper.down(pos))
          |> result.unwrap([])
          |> list.any(fn(d) { d == "RIGHT" })
        "RIGHT" ->
          dict.get(traversed, position_helper.left(pos))
          |> result.unwrap([])
          |> list.any(fn(d) { d == "DOWN" })
        "DOWN" ->
          dict.get(traversed, position_helper.up(pos))
          |> result.unwrap([])
          |> list.any(fn(d) { d == "LEFT" })
        "LEFT" ->
          dict.get(traversed, position_helper.right(pos))
          |> result.unwrap([])
          |> list.any(fn(d) { d == "UP" })
        _ -> panic as "Invalid direction"
      }
    })
  })
  |> dict.to_list
  |> io.debug
  |> list.length
  |> io.debug
}

// 3,6, LEFT => 4,6, UP =>  OK?
// 6,7, DOWN => 6,6, LEFT => OK?
// 7,7, RIGHT => 6,7, DOWN => OK?
// 1,8, LEFT => 2,6, UP (!) => MISSING
// 3,8, LEFT => 4,6, UP (!) MISSING
// 7,9, DOWN => 7,8, LEFT => MISSING
// 4,3, UP => WRONG
// 4,6, => WRONG

pub fn b(input: List(String)) {
  let max_x = input |> list.first() |> result.unwrap("") |> string.length
  let max_y = input |> list.length
  let grid = to_grid(input)

  let start_position = get_start_position(grid)
  traverse(
    grid,
    [#(start_position, start_position, "UP")],
    start_position,
    "UP",
    max_x - 1,
    max_y - 1,
  )
  |> build_traversed_b

  1
}
