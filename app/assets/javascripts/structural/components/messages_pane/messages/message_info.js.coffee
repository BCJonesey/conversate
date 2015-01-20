{timestampToHumanizedTimestr} = Structural.Data.Time
{div} = React.DOM

MessageInfo = React.createClass
  render: ->
    {Icon, ModalTrigger, FullEmailText} = Structural.Components

    if @props.includeSender
      name = Structural.Data.Participant.name(@props.message.user)
      sender = div {className: 'message-sender'}, name

    if @props.includeTime
      # We're being tricky and just flattening the timestamp props onto the
      # the component props.
      timestr = timestampToHumanizedTimestr(@props.message.timestamp,
                                            new Date(),
                                            @props)

    if @props.message.type == 'email_message'
      name = Structural.Data.Participant.name(@props.message.user)
      fullText = ModalTrigger({
        className: 'full-email-text'
        title: "#{name}'s Email Message"
        content: FullEmailText({message: @props.message})
      }, Icon({name: 'envelope-o'}))

    div {className: 'message-info'},
      div({className: 'message-details'}, fullText, timestr)
      sender

Structural.Components.MessageInfo = React.createFactory(MessageInfo)
