{timestampToHumanizedTimestr} = Structural.Data.Time
{div} = React.DOM

MessageInfo = React.createClass
  render: ->
    if @props.includeSender
      name = Structural.Data.Participant.name(@props.message.user)
      sender = div {className: 'message-sender'}, name

    if @props.includeTime
      # We're being tricky and just flattening the timestamp props onto the
      # the component props.
      timestr = timestampToHumanizedTimestr(@props.message.timestamp,
                                            new Date(),
                                            @props)
      time = div {className: 'message-details'}, timestr

    div {className: 'message-info'},
      time
      sender

Structural.Components.MessageInfo = MessageInfo
