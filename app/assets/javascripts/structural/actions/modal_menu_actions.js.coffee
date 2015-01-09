Structural.Actions.OpenModal = Hippodrome.createAction
  displayName: 'Open Modal'
  build: (content, title) ->
    content: content
    title: title

Structural.Actions.ReplaceModalContent = Hippodrome.createAction
  displayName: 'Replace Modal Content'
  build: (content) ->
    content: content

Structural.Actions.CloseModal = Hippodrome.createAction
  displayName: 'Close Modal'
  build: () -> {}

Structural.Actions.OpenMenu = Hippodrome.createAction
  displayName: 'Open Menu'
  build: (content, title, node) ->
    content: content
    title: title
    node: node

Structural.Actions.ReplaceMenuContent = Hippodrome.createAction
  displayName: 'Replace Menu Content'
  build: (content) ->
    content: content

Structural.Actions.CloseMenu = Hippodrome.createAction
  displayName: 'Close Menu'
  build: () -> {}
