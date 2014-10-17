{div} = React.DOM

MessageText = React.createClass
  render: ->
    div {className: 'message-text'}, @props.message.text

Structural.Components.MessageText = MessageText
