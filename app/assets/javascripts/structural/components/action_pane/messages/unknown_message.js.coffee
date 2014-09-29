{div} = React.DOM

UnknownMessage = React.createClass
  displayName: 'Unknown Message'

  render: ->
    div({className: 'message unknown-message'})

Structural.Components.UnknownMessage = UnknownMessage
