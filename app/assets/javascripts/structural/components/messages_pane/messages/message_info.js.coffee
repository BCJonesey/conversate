{timestampToHumanizedTimestr} = Structural.Data.Time
{div} = React.DOM

MessageInfo = React.createClass
  render: ->
    {Icon} = Structural.Components

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
      fullText = Icon {name: 'envelope-o', className: 'full-email-text'}

    div {className: 'message-info'},
      div({className: 'message-details'}, fullText, timestr)
      sender

Structural.Components.MessageInfo = MessageInfo
