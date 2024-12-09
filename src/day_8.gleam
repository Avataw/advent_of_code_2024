import gleam/bool
import gleam/dict
import gleam/list
import gleam/pair
import gleam/string
import position_helper

fn parse_grid(input: List(String)) {
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

fn find_antinodes(
  grid: dict.Dict(position_helper.Position, String),
  antenna: String,
  with_resonance: Bool,
) {
  let antenna_combinations =
    dict.filter(grid, fn(_, value) { value == antenna })
    |> dict.keys
    |> list.combination_pairs

  dict.filter(grid, fn(pos, _) {
    antenna_combinations
    |> list.any(fn(antennas) {
      let #(first, second) = antennas

      let first_distance = position_helper.distance(pos, first)
      let second_distance = position_helper.distance(pos, second)

      bool.and(
        position_helper.on_line(first, second, pos),
        with_resonance
          || bool.or(
          first_distance == 2 * second_distance,
          second_distance == 2 * first_distance,
        ),
      )
    })
  })
  |> dict.keys
}

pub fn a(input: List(String)) {
  let grid =
    input
    |> parse_grid

  grid
  |> dict.values
  |> list.unique
  |> list.filter(fn(a) { a != "." })
  |> list.flat_map(fn(a) { find_antinodes(grid, a, False) })
  |> list.unique
  |> list.length
}

pub fn b(input: List(String)) {
  let grid =
    input
    |> parse_grid

  grid
  |> dict.values
  |> list.unique
  |> list.filter(fn(a) { a != "." })
  |> list.flat_map(fn(a) { find_antinodes(grid, a, True) })
  |> list.unique
  |> list.length
}
