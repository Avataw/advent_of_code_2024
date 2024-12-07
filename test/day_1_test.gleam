import day_1
import gleeunit/should
import test_helper

pub fn a_example_test() {
  test_helper.get_input_lines(1, True)
  |> day_1.a()
  |> should.equal(11)
}

pub fn a_input_test() {
  test_helper.get_input_lines(1, False)
  |> day_1.a()
  |> should.equal(1_938_424)
}

pub fn b_example_test() {
  test_helper.get_input_lines(1, True)
  |> day_1.b()
  |> should.equal(31)
}

pub fn b_input_test() {
  test_helper.get_input_lines(1, False)
  |> day_1.b()
  |> should.equal(22_014_209)
}
