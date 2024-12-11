import day_9
import gleeunit/should
import test_helper

pub fn a_example_test() {
  test_helper.get_input_lines("day9", True)
  |> day_9.a()
  |> should.equal(1928)
}

pub fn a_input_test() {
  test_helper.get_input_lines("day9", False)
  |> day_9.a()
  |> should.equal(6_332_189_866_718)
}

pub fn b_example_test() {
  test_helper.get_input_lines("day9", True)
  |> day_9.b()
  |> should.equal(2858)
}
// takes two seconds -.-
// pub fn b_input_test() {
//   test_helper.get_input_lines("day9", False)
//   |> day_9.b()
//   |> should.equal(6_353_648_390_778)
// }
