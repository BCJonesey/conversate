{div, label, input} = React.DOM

ConversationDetailsEditor = React.createClass
  displayName: 'Conversation Details Editor'
  render: ->
    {Icon, Button} = Structural.Components

    div {className: 'conversation-details-editor'},
      div({className: 'section-header'}, 'Status')
      div({className: 'pin-unpin'},
        Icon({name: 'thumb-tack'})
        if @props.conversation.pinned then 'Unpin' else 'Pin'
        ' Conversation')
      div({className: 'archive-unarchive'},
        Icon({name: 'inbox'})
        if @props.conversation.archived then 'Unarchive' else 'Archive'
        ' Conversation')
      div({className: 'section-header'}, 'Title')
      div({className: 'change-title'},
        label({for: 'conversation-title-input'}, 'Change title (for everyone)')
        input({type: 'text', id: 'conversation-title-input', value: @props.conversation.title})
        Button({}, 'Update Title'))

Structural.Components.ConversationDetailsEditor = ConversationDetailsEditor
