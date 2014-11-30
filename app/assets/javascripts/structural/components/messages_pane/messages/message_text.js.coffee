{isUnread} = Structural.Data.Message
{annotateUrls} = Structural.Data.Text
{div, span} = React.DOM

MessageText = React.createClass
  displayName: 'Message Text'
  render: ->
    {MessageLink, MessageImageLink} = Structural.Components

    klass = 'message-text'

    unread = isUnread(@props.message, @props.conversation)
    if unread
      klass = "#{klass} unread-message-text"

    textFragments = annotateUrls(@props.message.text)
    fragments = _.map textFragments, (fragment, i) ->
      if fragment.type == 'text'
        span({key: i}, fragment.value)
      else if fragment.type == 'url'
        if fragment.urlType == 'image'
          MessageImageLink({key: i, url: fragment.value})
        else
          MessageLink({key: i, url: fragment.value})

    div {className: klass, onClick: @onClick}, fragments

  onClick: ->
    unread = isUnread(@props.message, @props.conversation)
    if unread
      Structural.Actions.MarkRead(@props.message, @props.conversation, @props.folder)

Structural.Components.MessageText = MessageText
