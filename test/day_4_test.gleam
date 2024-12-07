import day_4
import gleeunit/should
import test_helper

pub fn a_example_test() {
  test_helper.get_input_lines("day4", True)
  |> day_4.a()
  |> should.equal(18)
}

pub fn a_input_test() {
  test_helper.get_input_lines("day4", False)
  |> day_4.a()
  |> should.equal(2517)
}

pub fn b_example_test() {
  test_helper.get_input_lines("day4", True)
  |> day_4.b()
  |> should.equal(9)
}

pub fn b_input_test() {
  test_helper.get_input_lines("day4", False)
  |> day_4.b()
  |> should.equal(1960)
}
