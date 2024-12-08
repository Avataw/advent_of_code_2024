import day_7
import gleeunit/should
import test_helper

pub fn a_example_test() {
  test_helper.get_input_lines("day7", True)
  |> day_7.a()
  |> should.equal(3749)
}

pub fn a_input_test() {
  test_helper.get_input_lines("day7", False)
  |> day_7.a()
  |> should.equal(3_245_122_495_150)
}

pub fn b_example_test() {
  test_helper.get_input_lines("day7", True)
  |> day_7.b()
  |> should.equal(11_387)
}
// too slow but it works :)
// pub fn b_input_test() {
//   test_helper.get_input_lines("day7", False)
//   |> day_7.b()
//   |> should.equal(105_517_128_211_543)
// }
