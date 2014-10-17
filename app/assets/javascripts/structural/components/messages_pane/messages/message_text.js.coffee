{isUnread} = Structural.Data.Message
{div} = React.DOM

MessageText = React.createClass
  render: ->
    klass = 'message-text'

    unread = isUnread(@props.message, @props.conversation)
    if unread
      klass = "#{klass} unread-message-text"

    div {className: klass}, @props.message.text

Structural.Components.MessageText = MessageText
