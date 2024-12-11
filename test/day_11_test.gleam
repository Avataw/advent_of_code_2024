import day_11
import gleeunit/should
import test_helper

pub fn a_first_example_test() {
  test_helper.get_input_lines("day11", True)
  |> day_11.a()
  |> should.equal(55_312)
}

pub fn a_input_test() {
  test_helper.get_input_lines("day11", False)
  |> day_11.a()
  |> should.equal(218_079)
}

pub fn b_input_test() {
  test_helper.get_input_lines("day11", False)
  |> day_11.b()
  |> should.equal(259_755_538_429_618)
}
