import day_2
import gleeunit/should
import test_helper

pub fn a_example_test() {
  test_helper.get_input_lines("day2", True)
  |> day_2.a()
  |> should.equal(2)
}

pub fn a_input_test() {
  test_helper.get_input_lines("day2", False)
  |> day_2.a()
  |> should.equal(390)
}

pub fn b_example_test() {
  test_helper.get_input_lines("day2", True)
  |> day_2.b()
  |> should.equal(4)
}

pub fn b_input_test() {
  test_helper.get_input_lines("day2", False)
  |> day_2.b()
  |> should.equal(439)
}
