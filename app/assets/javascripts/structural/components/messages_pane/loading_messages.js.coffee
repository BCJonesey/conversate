{div} = React.DOM

LoadingMessages = React.createClass
  displayName: 'Loading Messages'
  render: ->
    div {className: 'loading-messages'}, 'Loading...'

Structural.Components.LoadingMessages = React.createFactory(LoadingMessages)
