import day_14
import gleeunit/should
import test_helper

pub fn a_example_test() {
  test_helper.get_input_lines("day14", True)
  |> day_14.a(day_14.Space(11, 7))
  |> should.equal(12)
}

pub fn a_input_test() {
  test_helper.get_input_lines("day14", False)
  |> day_14.a(day_14.Space(101, 103))
  |> should.equal(224_357_412)
}
// don't want to write files every test
// pub fn b_input_test() {
//   test_helper.get_input_lines("day14", False)
//   |> day_14.b(day_14.Space(101, 103))
//   |> should.equal(7083)
// }
