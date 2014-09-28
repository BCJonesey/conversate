{div} = React.DOM

ActionList = React.createClass
  displayName: 'Action List'

  getDefaultProps: -> messages: []

  render: ->

    messages = _.map(@props.messages, ((message) ->
      Structural.Components.Message(message: message, key: message.id)
    ),this)

    div className: 'act-list ui-scrollable',
      messages


Structural.Components.ActionList = ActionList
