{div} = React.DOM

LoadingConversations = React.createClass
  displayName: 'Loading Conversations'
  render: ->
    {Icon} = Structural.Components

    div {className: 'loading-conversations'},
      Icon({name: 'gear', spin: true})
      div({className: 'loading-message'}, 'Loading...')

Structural.Components.LoadingConversations =
  React.createFactory(LoadingConversations)
