import gleam/dict
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import parse_helper

type Entry {
  File(id: Int, value: Int)
  Space(value: Int)
}

fn parse(input: List(String)) -> List(Entry) {
  input
  |> list.first
  |> result.unwrap("")
  |> string.split("")
  |> list.map(parse_helper.to_int)
  |> list.index_map(fn(value, index) {
    case index % 2 == 0 {
      True -> File(index / 2, value)
      False -> Space(value)
    }
  })
}

fn expand_files(entries: List(Entry)) {
  entries
  |> list.fold(dict.new(), fn(acc, entry) {
    case entry {
      File(id, value) -> {
        list.repeat(id, value)
        |> list.fold(acc, fn(inner_acc, id) {
          dict.insert(inner_acc, dict.size(inner_acc), id)
        })
      }
      Space(_) -> acc
    }
  })
}

fn defrag(entries: List(Entry), files: dict.Dict(Int, Int)) {
  entries
  |> list.fold(#(dict.new(), files), fn(acc, entry) {
    let #(result, files) = acc

    case entry {
      File(id, value) -> {
        let next_result =
          list.repeat(id, value)
          |> list.fold(result, fn(result_acc, id) {
            dict.insert(result_acc, dict.size(result_acc), id)
          })

        #(next_result, files)
      }
      Space(value) -> {
        list.repeat(-1, value)
        |> list.fold(acc, fn(result_acc, _) {
          let #(result, files) = result_acc
          let last_file = case files |> dict.get(dict.size(files) - 1) {
            Error(_) -> panic as "this should never be empty"
            Ok(last_file) -> last_file
          }

          let next_result = dict.insert(result, dict.size(result), last_file)
          let next_files = files |> dict.delete(dict.size(files) - 1)

          #(next_result, next_files)
        })
      }
    }
  })
  |> pair.first
}

pub fn a(input: List(String)) {
  let entries =
    input
    |> parse

  let files = expand_files(entries)

  entries
  |> defrag(files)
  |> dict.to_list
  |> list.sort(fn(a, b) { int.compare(pair.first(a), pair.first(b)) })
  |> list.take(files |> dict.size)
  |> list.map(fn(cur) {
    let #(id, value) = cur

    id * value
  })
  |> int.sum
}

fn defrag_b(entries: List(Entry), files: List(Entry)) {
  entries
  |> list.fold(#([], files), fn(acc, entry) {
    let #(result, files) = acc

    let was_moved = case entry {
      File(_, _) -> files |> list.contains(entry) == False
      Space(_) -> False
    }

    case was_moved {
      True -> {
        let next_result = case entry {
          File(_, value) -> [Space(value), ..result]
          Space(_) -> panic as "Spaces don't get moved!"
        }

        #(next_result, files)
      }
      False -> {
        case entry {
          File(_, _) -> {
            #(
              [entry, ..result],
              files |> list.filter(fn(file) { file != entry }),
            )
          }
          Space(value) -> {
            let #(fitting_files, rest) =
              files
              |> list.filter(fn(file) {
                case file {
                  File(_, file_value) -> file_value <= value
                  Space(_) -> False
                }
              })
              |> list.fold(#([], value), fn(inner_acc, inner_cur) {
                let #(inner_result, inner_value) = inner_acc

                let file_length = case inner_cur {
                  File(_, file_length) -> file_length
                  Space(_) -> -1
                }

                let next_inner_value = inner_value - file_length

                case next_inner_value < 0 {
                  True -> inner_acc
                  False -> #([inner_cur, ..inner_result], next_inner_value)
                }
              })

            let next_result = case rest == 0 {
              True -> {
                list.flatten([fitting_files, result])
              }
              False -> {
                list.flatten([[Space(rest)], fitting_files, result])
              }
            }

            let next_files =
              files
              |> list.filter(fn(file) {
                case file {
                  File(id, _) ->
                    fitting_files
                    |> list.map(fn(file) {
                      case file {
                        File(id, _) -> id
                        Space(_) -> -1
                      }
                    })
                    |> list.contains(id)
                    == False
                  Space(_) -> panic as "this should never include spaces"
                }
              })

            #(next_result, next_files)
          }
        }
      }
    }
  })
  |> pair.first
}

fn expand_entries(entries: List(Entry)) {
  entries
  |> list.flat_map(fn(entry) {
    case entry {
      File(id, value) -> list.repeat(id, value)
      Space(value) -> list.repeat(-1, value)
    }
  })
}

pub fn b(input: List(String)) {
  let entries =
    input
    |> parse

  let files =
    entries
    |> list.filter(fn(entry) {
      case entry {
        File(_, _) -> True
        Space(_) -> False
      }
    })
    |> list.reverse

  entries
  |> defrag_b(files)
  |> list.reverse
  |> expand_entries
  |> list.index_map(fn(value, index) {
    case value {
      -1 -> 0
      _ -> index * value
    }
  })
  |> int.sum
}
