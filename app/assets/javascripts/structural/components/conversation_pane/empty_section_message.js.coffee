{div} = React.DOM
{articleFor} = Structural.Data.English

EmptySectionMessage = React.createClass
  displayName: 'Empty Section Message'
  render: ->
    if @props.adjective == ''
      # The default section is empty.  Saying "this folder has no conversations"
      # is probably wrong, and "what's a conversation" is the wrong question to
      # ask.  This is awkward and special-cased, but that's life.
      message = 'All the conversations here are shared, archived or pinned.'
      prompt = 'how do I start a conversation?'
    else
      message = "This folder doesn't have any #{@props.adjective} conversations."
      prompt = "what's #{articleFor(@props.adjective)} #{@props.adjective} conversation?"

    div {className: 'empty-section-message'},
      div({className: 'message'}, message)
      div({className: 'prompt'}, prompt)

Structural.Components.EmptySectionMessage = EmptySectionMessage
