{isUnread} = Structural.Data.Message
{div} = React.DOM

MessageText = React.createClass
  render: ->
    klass = 'message-text'

    unread = isUnread(@props.message, @props.conversation)
    if unread
      klass = "#{klass} unread-message-text"

    div {className: klass, onClick: @onClick}, @props.message.text

  onClick: ->
    unread = isUnread(@props.message, @props.conversation)
    if unread
      Structural.Actions.MarkRead(@props.message, @props.conversation)

Structural.Components.MessageText = MessageText
