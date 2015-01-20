{PinUnpinConversation, ArchiveUnarchiveConversation, RetitleConversation} = Structural.Actions
{div, label, input} = React.DOM

ConversationDetailsEditor = React.createClass
  displayName: 'Conversation Details Editor'
  getInitialState: ->
    title: @props.conversation.title

  render: ->
    {Icon, Button} = Structural.Components

    div {className: 'conversation-details-editor'},
      div({className: 'section-header'}, 'Status')
      div({className: 'pin-unpin', onClick: @pinUnpin},
        Icon({name: 'thumb-tack'})
        if @props.conversation.pinned then 'Unpin' else 'Pin'
        ' Conversation')
      div({className: 'archive-unarchive', onClick: @archiveUnarchive},
        Icon({name: 'inbox'})
        if @props.conversation.archived then 'Unarchive' else 'Archive'
        ' Conversation')
      div({className: 'section-header'}, 'Title')
      div({className: 'change-title'},
        label({htmlFor: 'conversation-title-input'}, 'Change title (for everyone)')
        input({
          type: 'text'
          id: 'conversation-title-input'
          value: @state.title
          onChange: @setTitle
        })
        Button({
          action: RetitleConversation
          actionArgs: [@state.title, @props.conversation, @props.folder, @props.currentUser]
        }, 'Update Title'))

  setTitle: (event) ->
    @setState(title: event.target.value)

  pinUnpin: (event) ->
    PinUnpinConversation(not @props.conversation.pinned, @props.conversation, @props.folder, @props.currentUser)
  archiveUnarchive: (event) ->
    ArchiveUnarchiveConversation(not @props.conversation.archived, @props.conversation, @props.folder, @props.currentUser)

Structural.Components.ConversationDetailsEditor =
  React.createFactory(ConversationDetailsEditor)
