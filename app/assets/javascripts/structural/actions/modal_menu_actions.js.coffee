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
