{div} = React.DOM

MessagesList = React.createClass
  displayName: 'Action List'

  getDefaultProps: -> messages: []

  render: ->

    messages = _.map(@props.messages, ((message) ->
      Structural.Components.Message(message: message, key: message.id)
    ),this)

    div className: 'messages-list',
      messages


Structural.Components.MessagesList = MessagesList
