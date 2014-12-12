Structural.Actions.OpenModal = new Hippodrome.Action(
  'Open Modal',
  (content, title) ->
    content: content
    title: title
)

Structural.Actions.ReplaceModalContent = new Hippodrome.Action(
  'Replace Modal Content',
  (content) ->
    content: content
)

Structural.Actions.CloseModal = new Hippodrome.Action(
  'Close Modal',
  () -> {}
)

Structural.Actions.OpenMenu = new Hippodrome.Action(
  'Open Menu',
  (content, title, node) ->
    content: content
    title: title
    node: node
)

Structural.Actions.ReplaceMenuContent = new Hippodrome.Action(
  'Replace Menu Content'
  (content) ->
    content: content
)

Structural.Actions.CloseMenu = new Hippodrome.Action(
  'Close Menu'
  () -> {}
)
