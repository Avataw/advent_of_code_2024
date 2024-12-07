pub type Position {
  Position(x: Int, y: Int)
}

pub fn down(position: Position) {
  Position(x: position.x, y: position.y + 1)
}

pub fn up(position: Position) {
  Position(x: position.x, y: position.y - 1)
}

pub fn left(position: Position) {
  Position(x: position.x - 1, y: position.y)
}

pub fn right(position: Position) {
  Position(x: position.x + 1, y: position.y)
}

pub fn down_right(position: Position) {
  position |> down |> right
}

pub fn down_left(position: Position) {
  position |> down |> left
}

pub fn up_right(position: Position) {
  position |> up |> right
}

pub fn up_left(position: Position) {
  position |> up |> left
}
