{div} = React.DOM
{articleFor} = Structural.Data.English
{capitalize} = Structural.Data.Text

EmptySectionMessage = React.createClass
  displayName: 'Empty Section Message'
  render: ->
    {MenuTrigger, TextOnlyMenuContent} = Structural.Components

    if @props.adjective == ''
      # The default section is empty.  Saying "this folder has no conversations"
      # is probably wrong, and "what's a conversation" is the wrong question to
      # ask.  This is awkward and special-cased, but that's life.
      message = 'All the conversations here are shared, archived or pinned.'
      prompt = undefined
    else
      message = "This folder doesn't have any #{@props.adjective} conversations."
      promptText = "what's #{articleFor(@props.adjective)} #{@props.adjective}
                    conversation?"
      prompt = MenuTrigger({
        className: 'prompt'
        title: "#{capitalize(@props.adjective)} Conversations"
        content: TextOnlyMenuContent({}, @props.description)
      }, promptText)

    div {className: 'empty-section-message'},
      div({className: 'message'}, message)
      prompt

Structural.Components.EmptySectionMessage = EmptySectionMessage
