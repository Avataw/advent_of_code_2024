import gleam/result
import gleam/string
import simplifile

pub fn get_input_lines(day: String, example: Bool) -> List(String) {
  let filepath =
    "input/"
    <> day
    <> case example {
      True -> ".example.txt"
      False -> ".txt"
    }

  simplifile.read(filepath)
  |> result.unwrap("")
  |> string.split("\n")
}
