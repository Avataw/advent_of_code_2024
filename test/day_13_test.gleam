import day_13
import gleeunit/should
import test_helper

pub fn a_example_test() {
  test_helper.get_input_lines("day13", True)
  |> day_13.a()
  |> should.equal(480)
}

pub fn a_input_test() {
  test_helper.get_input_lines("day13", False)
  |> day_13.a()
  |> should.equal(35_082)
}

pub fn b_input_test() {
  test_helper.get_input_lines("day13", False)
  |> day_13.b()
  |> should.equal(82_570_698_600_470)
}
