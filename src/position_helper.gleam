import gleam/int

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

pub fn adjacent(position: Position) {
  [up(position), right(position), down(position), left(position)]
}

pub fn distance(a: Position, b: Position) -> Int {
  int.absolute_value(a.x - b.x) + int.absolute_value(a.y - b.y)
}

pub fn on_line(a: Position, b: Position, c: Position) -> Bool {
  let m1 = int.multiply(a.y - b.y, a.x - c.x)
  let m2 = int.multiply(a.y - c.y, a.x - b.x)

  m1 == m2
}

pub fn is_equal(a: Position, b: Position) -> Bool {
  a.x == b.x && a.y == b.y
}
