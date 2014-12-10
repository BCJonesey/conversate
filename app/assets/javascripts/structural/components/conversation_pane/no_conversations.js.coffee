{div} = React.DOM

NoConversations = React.createClass
  displayName: 'No Conversations'
  render: ->
    {MenuTrigger, TextOnlyMenuContent} = Structural.Components

    menuMessage = "Use the '+' button just above this message.  Give your
                  conversation a title, include some friends and start chatting."

    div {className: 'no-conversations'},
      div({className: 'message'}, 'There aren\'t any conversations in this folder')
      MenuTrigger({
        className: 'prompt'
        title: 'New Conversation'
        content: TextOnlyMenuContent({}, menuMessage)
      }, 'how do I start a new conversation?')

Structural.Components.NoConversations = NoConversations
