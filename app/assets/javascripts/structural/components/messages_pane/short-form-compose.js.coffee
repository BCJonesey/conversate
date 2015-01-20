{div} = React.DOM

ShortFormCompose = React.createClass
  displayName: 'Short Form Compose'
  render: ->
    div {className: 'short-form-compose clearfix'}

Structural.Components.ShortFormCompose = React.createFactory(ShortFormCompose)
