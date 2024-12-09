import day_8
import gleeunit/should
import test_helper

pub fn a_example_test() {
  test_helper.get_input_lines("day8", True)
  |> day_8.a()
  |> should.equal(14)
}

pub fn a_input_test() {
  test_helper.get_input_lines("day8", False)
  |> day_8.a()
  |> should.equal(329)
}

pub fn b_example_test() {
  test_helper.get_input_lines("day8", True)
  |> day_8.b()
  |> should.equal(34)
}

pub fn b_input_test() {
  test_helper.get_input_lines("day8", False)
  |> day_8.b()
  |> should.equal(1190)
}
