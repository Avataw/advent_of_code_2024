import gleam/int

pub fn to_int(s: String) {
  case int.parse(s) {
    Ok(i) -> i
    _ -> panic as "String could not be parsed as int"
  }
}
