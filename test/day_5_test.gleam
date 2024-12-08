import day_5
import gleeunit/should
import test_helper

pub fn a_example_test() {
  test_helper.get_input_lines("day5", True)
  |> day_5.a()
  |> should.equal(143)
}

pub fn a_input_test() {
  test_helper.get_input_lines("day5", False)
  |> day_5.a()
  |> should.equal(5268)
}

pub fn b_example_test() {
  test_helper.get_input_lines("day5", True)
  |> day_5.b()
  |> should.equal(123)
}

pub fn b_input_test() {
  test_helper.get_input_lines("day5", False)
  |> day_5.b()
  |> should.equal(5799)
}
