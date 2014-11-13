{div} = React.DOM

NoConversations = React.createClass
  displayName: 'No Conversations'
  render: ->
    div {className: 'no-conversations'},
      div({className: 'message'}, 'There aren\'t any conversations in this folder')
      div({className: 'prompt'}, 'how do I start a new conversation?')

Structural.Components.NoConversations = NoConversations
