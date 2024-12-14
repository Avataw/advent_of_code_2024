import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import parse_helper
import position_helper
import simplifile

type Position =
  position_helper.Position

type Velocity {
  Velocity(x: Int, y: Int)
}

type Security {
  Security(position: Position, velocity: Velocity)
}

pub type Space {
  Space(width: Int, height: Int)
}

fn parse(input: List(String)) {
  input
  |> list.map(fn(line) {
    case parse_helper.parse_numbers(line) {
      [p_x, p_y, v_x, v_y] ->
        Security(position_helper.Position(p_x, p_y), Velocity(v_x, v_y))
      _ -> panic as "invalid input"
    }
  })
}

fn calc_movement(securities: List(Security), space: Space) {
  securities
  |> list.map(fn(cur) {
    let next_pos_x = case
      int.modulo(cur.position.x + cur.velocity.x, space.width)
    {
      Error(_) -> panic as "Width cannot be right"
      Ok(x) -> x
    }

    let next_pos_y = case
      int.modulo(cur.position.y + cur.velocity.y, space.height)
    {
      Error(_) -> panic as "Height cannot be right"
      Ok(y) -> y
    }

    Security(position_helper.Position(next_pos_x, next_pos_y), cur.velocity)
  })
}

fn calc_safety_factor(end_positions: List(Position), space: Space) {
  let top_left =
    end_positions
    |> list.filter(fn(pos) {
      pos.x < space.width / 2 && pos.y < space.height / 2
    })

  let top_right =
    end_positions
    |> list.filter(fn(pos) {
      pos.x > space.width / 2 && pos.y < space.height / 2
    })

  let bottom_left =
    end_positions
    |> list.filter(fn(pos) {
      pos.x < space.width / 2 && pos.y > space.height / 2
    })

  let bottom_right =
    end_positions
    |> list.filter(fn(pos) {
      pos.x > space.width / 2 && pos.y > space.height / 2
    })

  [bottom_left, bottom_right, top_left, top_right]
  |> list.map(list.length)
  |> int.product
}

pub fn a(input: List(String), space: Space) {
  let securities =
    input
    |> parse

  list.repeat(0, 100)
  |> list.fold(securities, fn(acc, _) { calc_movement(acc, space) })
  |> list.map(fn(security) { security.position })
  |> calc_safety_factor(space)
}

pub fn b(input: List(String), space: Space) {
  let securities =
    input
    |> parse

  let assert Ok(Nil) = simplifile.write(to: "./find_tree.txt", contents: "")

  let offset = 7000

  let securities =
    list.range(1, offset)
    |> list.fold(securities, fn(acc, _) { calc_movement(acc, space) })

  list.range(1, 100)
  |> list.fold(securities, fn(acc, cur) {
    let assert Ok(Nil) =
      simplifile.append(
        to: "./find_tree.txt",
        contents: "\n" <> int.to_string(cur + offset) <> "\n",
      )

    let next_securities = calc_movement(acc, space)

    let positions =
      next_securities
      |> list.fold(dict.new(), fn(acc, cur) {
        acc |> dict.insert(cur.position, 1)
      })

    let str =
      list.range(0, space.height)
      |> list.map(fn(y) {
        list.range(0, space.width)
        |> list.map(fn(x) {
          case dict.has_key(positions, position_helper.Position(x, y)) {
            True -> "#"
            False -> "."
          }
        })
        |> string.join("")
      })
      |> string.join("\n")

    case string.contains(str, "##########") {
      True -> io.println("FOUND IT! " <> int.to_string(cur + offset))
      False -> Nil
    }

    let assert Ok(Nil) = simplifile.append(to: "./find_tree.txt", contents: str)

    next_securities
  })

  7083
}
