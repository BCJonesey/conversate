Logic = {
  not: (p) -> (args...) -> !p(args...)
  and: (p, q) -> (args...) -> if p(args...) then q(args...) else false
  or: (p, q) -> (args...) -> if p(args...) then true else q(args...)
}

Structural.Data.Logic = Logic
