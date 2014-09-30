{div} = React.DOM

Compose = React.createClass
  displayName: 'Compose'
  render: ->
    div {className: 'act-compose'},
      Structural.Components.ShortFormCompose()

Structural.Components.Compose = Compose
