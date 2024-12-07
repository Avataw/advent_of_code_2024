import day_3
import gleeunit/should
import test_helper

pub fn a_example_test() {
  test_helper.get_input_lines("day3_a", True)
  |> day_3.a()
  |> should.equal(161)
}

pub fn a_input_test() {
  test_helper.get_input_lines("day3", False)
  |> day_3.a()
  |> should.equal(170_068_701)
}

pub fn b_example_test() {
  test_helper.get_input_lines("day3_b", True)
  |> day_3.b()
  |> should.equal(48)
}

pub fn b_input_test() {
  test_helper.get_input_lines("day3", False)
  |> day_3.b()
  |> should.equal(78_683_433)
}
