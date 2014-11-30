{a} = React.DOM

MessageLink = React.createClass
  displayName: 'Message Link'
  render: ->
    a({className: 'message-link', href: @props.url, target: '_blank'}, @props.url)

Structural.Components.MessageLink = MessageLink
