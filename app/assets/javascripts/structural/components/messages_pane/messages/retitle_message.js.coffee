{div} = React.DOM

RetitleMessage = React.createClass
  displayName: 'Retitle Message'

  getDefaultProps: -> message: {}

  render: ->
    message = @props.message
    name = Structural.Data.Participant.name(message.user)
    div className: 'retitle-message',
      "#{name} titled the conversation \"#{message.title}\""

Structural.Components.RetitleMessage = React.createFactory(RetitleMessage)
