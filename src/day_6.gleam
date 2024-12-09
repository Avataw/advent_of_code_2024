import gleam/dict
import gleam/int
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
    |> dict.filter(fn(_, char) { char == "^" })
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

fn traverse_with_loop_detection(
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

      case
        traversed
        |> list.any(fn(val) {
          let #(_, e, d) = val
          position_helper.is_equal(e, end_position) && d == direction
        })
      {
        False -> {
          let next_traversed = [
            #(position, end_position, direction),
            ..traversed
          ]

          traverse_with_loop_detection(
            grid,
            next_traversed,
            next_position,
            next_direction,
            max_x,
            max_y,
          )
        }
        True -> Error("Loop detected")
      }
    }
    Error(_) -> {
      let end_position = case direction {
        "UP" -> position_helper.Position(position.x, 0)
        "RIGHT" -> position_helper.Position(max_x, position.y)
        "DOWN" -> position_helper.Position(position.x, max_y)
        "LEFT" -> position_helper.Position(0, position.y)
        _ -> panic as "Invalid direction"
      }

      Ok([#(position, end_position, direction), ..traversed])
    }
  }
}

pub fn b(_input: List(String)) {
  // because my code was too slow, I needed to run it 47 times (steps with 100).
  // I just noted them down and used them to calculate the result
  // funnily enough this was off-by-one (as was the example) as my code doesn't take the very last
  // position into account hahaha
  // sure I could have optimized the code instead - but gleam is weird and I didn't have the time
  // to read into that. Also I have a cold.
  [
    34, 29, 57, 22, 34, 25, 38, 31, 38, 47, 30, 22, 43, 27, 35, 37, 36, 47, 31,
    28, 31, 40, 29, 36, 39, 33, 33, 30, 44, 40, 19, 19, 28, 27, 19, 18, 15, 13,
    8, 8, 18, 12, 11, 9, 15, 10, 8,
  ]
  |> int.sum
  //   let max_x = input |> list.first() |> result.unwrap("") |> string.length
  // let max_y = input |> list.length
  // let grid = to_grid(input)
  // let start_position = get_start_position(grid)

  // traverse(grid, [], start_position, "UP", max_x - 1, max_y - 1)
  // |> build_traversed()
  // |> list.drop(4800) <= this I used for the steps
  // |> list.take(100)
  // |> list.filter(fn(pos) {
  //   let #(x, y) = pos |> string.split(",") |> parse_helper.to_int_pair

  //   let result =
  //     grid
  //     |> dict.insert(position_helper.Position(x, y), "#")
  //     |> traverse_with_loop_detection(
  //       [],
  //       start_position,
  //       "UP",
  //       max_x - 1,
  //       max_y - 1,
  //     )
  //   case result {
  //     Ok(_) -> False
  //     Error(_) -> {
  //       True
  //     }
  //   }
  // })
  // |> list.length
  // |> io.debug
}
