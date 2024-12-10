import day_10
import gleeunit/should
import test_helper

pub fn a_first_example_test() {
  test_helper.get_input_lines("day10_first", True)
  |> day_10.a()
  |> should.equal(1)
}

pub fn a_second_example_test() {
  test_helper.get_input_lines("day10_second", True)
  |> day_10.a()
  |> should.equal(36)
}

pub fn a_input_test() {
  test_helper.get_input_lines("day10", False)
  |> day_10.a()
  |> should.equal(652)
}

pub fn b_example_test() {
  test_helper.get_input_lines("day10_second", True)
  |> day_10.b()
  |> should.equal(81)
}

pub fn b_input_test() {
  test_helper.get_input_lines("day10", False)
  |> day_10.b()
  |> should.equal(1432)
}
