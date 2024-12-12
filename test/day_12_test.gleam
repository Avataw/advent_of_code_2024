import day_12
import gleeunit/should
import test_helper

pub fn a_first_example_test() {
  test_helper.get_input_lines("day12_first", True)
  |> day_12.a()
  |> should.equal(140)
}

pub fn a_second_example_test() {
  test_helper.get_input_lines("day12_second", True)
  |> day_12.a()
  |> should.equal(772)
}

// takes too long
// pub fn a_input_test() {
//   test_helper.get_input_lines("day12", False)
//   |> day_12.a()
//   |> should.equal(1_377_008)
// }

pub fn b_first_example_test() {
  test_helper.get_input_lines("day12_first", True)
  |> day_12.b()
  |> should.equal(80)
}
// takes too long :(
// pub fn b_input_test() {
//   test_helper.get_input_lines("day12", False)
//   |> day_12.b()
//   |> should.equal(815_788)
// }
