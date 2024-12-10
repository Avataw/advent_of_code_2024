import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import parse_helper
import position_helper

type Step {
  Step(pos: position_helper.Position, value: Int)
}

fn find_next_steps(
  grid: dict.Dict(position_helper.Position, Int),
  step: Step,
) -> List(Step) {
  step.pos
  |> position_helper.adjacent
  |> list.map(fn(adjacent) {
    let value = dict.get(grid, adjacent) |> result.unwrap(-1)
    Step(adjacent, value)
  })
  |> list.filter(fn(s) { step.value + 1 == s.value })
}

fn traverse(
  grid: dict.Dict(position_helper.Position, Int),
  step: Step,
  result: List(position_helper.Position),
) {
  case step.value {
    9 -> [step.pos, ..result]
    _ -> {
      let next = find_next_steps(grid, step)

      case list.is_empty(next) {
        True -> result
        False ->
          next
          |> list.flat_map(fn(n) { traverse(grid, n, result) })
      }
    }
  }
}

fn score_trails(grid: dict.Dict(position_helper.Position, Int), distinct: Bool) {
  grid
  |> dict.filter(fn(_, val) { val == 0 })
  |> dict.keys
  |> list.map(fn(start_pos) {
    case distinct {
      True ->
        traverse(grid, Step(start_pos, 0), [])
        |> list.length
      False ->
        traverse(grid, Step(start_pos, 0), [])
        |> list.unique
        |> list.length
    }
  })
}

pub fn a(input: List(String)) {
  parse_helper.parse_grid(input)
  |> dict.map_values(fn(_, val) { parse_helper.to_int(val) })
  |> score_trails(False)
  |> int.sum
}

pub fn b(input: List(String)) {
  parse_helper.parse_grid(input)
  |> dict.map_values(fn(_, val) { parse_helper.to_int(val) })
  |> score_trails(True)
  |> int.sum
}
