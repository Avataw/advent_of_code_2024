import day_6
import gleeunit/should
import test_helper

pub fn a_example_test() {
  test_helper.get_input_lines("day6", True)
  |> day_6.a()
  |> should.equal(41)
}
// this one is quite slow
// pub fn a_input_test() {
//   test_helper.get_input_lines("day6", False)
//   |> day_6.a()
//   |> should.equal(4789)
// }
// pub fn b_example_test() {
//   test_helper.get_input_lines("day6", True)
//   |> day_6.b()
//   |> should.equal(6)
// }

// this one is (obviously) super slow
// pub fn b_input_test() {
//   test_helper.get_input_lines("day6", False)
//   |> day_6.b()
//   |> should.equal(1304)
// }
