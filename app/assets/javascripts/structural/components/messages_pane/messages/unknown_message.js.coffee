{div} = React.DOM

UnknownMessage = React.createClass
  displayName: 'Unknown Message'

  render: ->
    div({className: 'message unknown-message'},
      "unknown message type: #{@props.message.type}")

Structural.Components.UnknownMessage = React.createFactory(UnknownMessage)
