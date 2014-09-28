{div} = React.DOM

ActionList = React.createClass
  displayName: 'Action List'

  getDefaultProps: -> messages: []

  render: ->
    messages = _.map(@props.messages, ((message) ->
      div className: 'message', key: message.id,
        "THIS IS A MESSAGE!!!"
    ), this)

    div className: 'act-list ui-scrollable',
      messages


Structural.Components.ActionList = ActionList
