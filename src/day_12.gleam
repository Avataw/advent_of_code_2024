import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import parse_helper
import position_helper

type Position =
  position_helper.Position

type Plant {
  Plant(id: String, position: Position, borders: Int, traversed: Bool)
}

fn grid_to_plants(
  grid: dict.Dict(Position, String),
) -> dict.Dict(Position, Plant) {
  grid
  |> dict.map_values(fn(pos, plant_id) {
    let borders =
      pos
      |> position_helper.adjacent
      |> list.count(fn(pos) {
        case grid |> dict.get(pos) {
          Error(_) -> True
          Ok(v) -> v != plant_id
        }
      })

    Plant(plant_id, pos, borders, False)
  })
}

fn traverse(grid: dict.Dict(Position, Plant), plot: List(Plant), current: Plant) {
  case current.traversed {
    True -> #(grid, plot)
    False -> {
      let next_current =
        Plant(current.id, current.position, current.borders, True)

      let next_grid =
        grid
        |> dict.insert(current.position, next_current)

      let adjacents =
        current.position
        |> position_helper.adjacent
        |> list.filter_map(fn(pos) { dict.get(grid, pos) })
        |> list.filter(fn(plant) {
          plant.traversed == False && plant.id == current.id
        })

      let next_plot = [next_current, ..plot]

      case adjacents |> list.is_empty {
        True -> #(next_grid, next_plot)
        False ->
          adjacents
          |> list.fold(#(next_grid, next_plot), fn(acc, adjacent_plant) {
            let #(cur_grid, cur_plot) = acc
            traverse(cur_grid, [next_current, ..cur_plot], adjacent_plant)
          })
      }
    }
  }
}

pub fn a(input: List(String)) {
  let grid =
    input
    |> parse_helper.parse_grid
    |> grid_to_plants

  grid
  |> dict.values
  |> list.fold(#(grid, []), fn(acc, cur) {
    let #(cur_grid, plots) = acc

    case cur_grid |> dict.get(cur.position) {
      Error(_) -> panic as "This cannot be empty"
      Ok(current) if current.traversed -> acc
      _ -> {
        let #(next_grid, plot) = traverse(cur_grid, [], cur)
        #(next_grid, [plot, ..plots] |> list.unique)
      }
    }
  })
  |> pair.second
  |> list.map(fn(plants) {
    let unique_plants = list.unique(plants)
    let perimeter =
      unique_plants
      |> list.map(fn(cur) { cur.borders })
      |> int.sum

    let area = unique_plants |> list.length
    perimeter * area
  })
  |> int.sum
}

pub fn b(input: List(String)) {
  2
}
