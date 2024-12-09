import gleeunit/should
import position_helper.{Position}

// #(Position(4, 3), Position(8, 4), Position(2, 0))
pub fn on_line_diagonal() {
  let #(diagonal_first, diagonal_second, diagonal_third) = #(
    Position(4, 3),
    Position(8, 4),
    Position(2, 0),
  )

  let not_diagonal = Position(0, 10)

  position_helper.on_line(diagonal_first, diagonal_second, diagonal_third)
  |> should.be_true

  position_helper.on_line(diagonal_first, diagonal_second, not_diagonal)
  |> should.be_false
}
