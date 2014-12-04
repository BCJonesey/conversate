{isUnread} = Structural.Data.Message
{annotateUrls} = Structural.Data.Text
{div, span, a} = React.DOM

messageTextFragments = (message) ->
  {MessageLink, MessageImageLink} = Structural.Components

  textFragments = annotateUrls(message.text)
  _.map textFragments, (fragment, i) ->
    if fragment.type == 'text'
      span({key: i}, fragment.value)
    else if fragment.type == 'url'
      if fragment.urlType == 'image'
        MessageImageLink({key: i, url: fragment.value})
      else
        MessageLink({key: i, url: fragment.value})

uploadMessageText = (message) ->
  {Icon} = Structural.Components

  [
    div({className: 'upload-link', key: 'upload-link'},
      Icon({name: 'file'}),
      a({href: message.fileUrl, target: '_blank'}, message.fileName))
    div({className: 'upload-notes', key: 'upload-notes'}, message.notes)
  ]

MessageText = React.createClass
  displayName: 'Message Text'
  render: ->
    klass = 'message-text'

    unread = isUnread(@props.message, @props.conversation)
    if unread
      klass = "#{klass} unread-message-text"

    if @props.message.type == 'upload_message'
      contents = uploadMessageText(@props.message)
    else
      contents = messageTextFragments(@props.message)

    div {className: klass, onClick: @onClick}, contents

  onClick: ->
    unread = isUnread(@props.message, @props.conversation)
    if unread
      Structural.Actions.MarkRead(@props.message, @props.conversation, @props.folder)

Structural.Components.MessageText = MessageText
