Structural.Actions.OpenModal = new Hippodrome.Action(
  'Open Modal',
  (content, title) ->
    content: content
    title: title
)

Structural.Actions.CloseModal = new Hippodrome.Action(
  'Close Modal',
  () -> {}
)

Structural.Actions.OpenMenu = new Hippodrome.Action(
  'Open Menu',
  (content, node) ->
    content: content
    node: node
)

Structural.Actions.CloseMenu = new Hippodrome.Action(
  'Close Menu'
  () -> {}
)
