import gleam/int
import gleam/list
import gleam/pair
import gleam/regexp
import gleam/result
import parse_helper

type Button {
  Button(x: Int, y: Int, token: Int)
}

type Prize {
  Prize(x: Int, y: Int)
}

type Configuration {
  Configuration(a: Button, b: Button, prize: Prize)
}

fn parse_numbers(input: String) {
  let numbers = case regexp.from_string("\\d+") {
    Error(_) -> panic as "This is an invalid regex"
    Ok(regexp) -> regexp
  }
  regexp.scan(numbers, input)
  |> list.map(fn(match) { match.content })
  |> parse_helper.to_int_pair
}

fn parse(input: List(String)) {
  case input {
    [first, second, third, ..] -> {
      let #(a_x, a_y) = parse_numbers(first)
      let #(b_x, b_y) = parse_numbers(second)
      let #(prize_x, prize_y) = parse_numbers(third)

      let a = Button(a_x, a_y, 3)
      let b = Button(b_x, b_y, 1)
      let prize = Prize(prize_x, prize_y)

      Configuration(a, b, prize)
    }
    _ -> panic as "This is an invalid input"
  }
}

fn solve(config: Configuration) {
  let a_times =
    int.min(config.prize.x / config.a.x, config.prize.y / config.a.y)
  let b_times =
    int.min(config.prize.x / config.b.x, config.prize.y / config.b.y)

  let a_presses =
    list.range(0, a_times)
    |> list.index_map(fn(value, index) {
      #(index, #(value * config.a.x, value * config.a.y))
    })

  list.range(0, b_times)
  |> list.index_map(fn(value, index) {
    #(index, #(value * config.b.x, value * config.b.y))
  })
  |> list.reverse
  |> list.find_map(fn(b_pair) {
    let #(index, value) = b_pair
    let #(x, y) = value

    let missing = #(config.prize.x - x, config.prize.y - y)

    let matching_a =
      a_presses
      |> list.find(fn(a_pair) {
        let #(_, a_value) = a_pair
        a_value == missing
      })

    case matching_a {
      Error(_) -> Error("None Found")
      Ok(a) -> Ok(#(index, a |> pair.first))
    }
  })
}

pub fn a(input: List(String)) {
  input
  |> list.sized_chunk(4)
  |> list.map(fn(lines) { parse(lines) |> solve })
  |> list.fold(0, fn(acc, cur) {
    case cur {
      Error(_) -> acc
      Ok(values) -> {
        let #(b_times, a_times) = values
        let result = a_times * 3 + b_times
        acc + result
      }
    }
  })
}

fn parse_b(input: List(String)) {
  case input {
    [first, second, third, ..] -> {
      let #(a_x, a_y) = parse_numbers(first)
      let #(b_x, b_y) = parse_numbers(second)
      let #(prize_x, prize_y) = parse_numbers(third)

      let a = Button(a_x, a_y, 3)
      let b = Button(b_x, b_y, 1)
      let prize =
        Prize(prize_x + 10_000_000_000_000, prize_y + 10_000_000_000_000)

      Configuration(a, b, prize)
    }
    _ -> panic as "This is an invalid input"
  }
}

// do some math I totally did not copy from a reddit post. Yeah yeah linear algebra and stuff
fn solve_b(config: Configuration) {
  let det = config.a.x * config.b.y - config.a.y * config.b.x
  let a =
    config.prize.x * config.b.y - config.prize.y * config.b.x
    |> int.divide(det)
    |> result.unwrap(0)
  let b =
    config.prize.y * config.a.x - config.prize.x * config.a.y
    |> int.divide(det)
    |> result.unwrap(0)

  let matches_a = config.a.x * a + config.b.x * b == config.prize.x
  let matches_b = config.a.y * a + config.b.y * b == config.prize.y

  case matches_a && matches_b {
    True -> Ok(#(b, a))
    False -> Error(Nil)
  }
}

pub fn b(input: List(String)) {
  input
  |> list.sized_chunk(4)
  |> list.map(fn(lines) { parse_b(lines) |> solve_b })
  |> list.fold(0, fn(acc, cur) {
    case cur {
      Error(_) -> acc
      Ok(values) -> {
        let #(b_times, a_times) = values
        let result = a_times * 3 + b_times
        acc + result
      }
    }
  })
}
