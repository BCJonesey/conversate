{div} = React.DOM

TextOnlyMenuContent = React.createClass
  displayName: 'Text Only Menu Content'
  render: ->
    div {className: 'text-only-menu-content'}, @props.children

Structural.Components.TextOnlyMenuContent =
  React.createFactory(TextOnlyMenuContent)
