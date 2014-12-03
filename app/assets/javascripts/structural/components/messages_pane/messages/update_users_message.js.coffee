{listAsReadableString} = Structural.Data.English
{div} = React.DOM

UpdateUsersMessage = React.createClass
  render: ->
    addedNames = _.map(@props.message.added, Structural.Data.Participant.name)
    removedNames = _.map(@props.message.removed, Structural.Data.Participant.name)

    addedStr = listAsReadableString(addedNames)
    removedStr = listAsReadableString(removedNames)
    name = Structural.Data.Participant.name(@props.message.user)

    if addedNames.length > 0
      addedStr = "added #{addedStr}"

    if removedNames.length > 0
      removedStr = "removed #{removedStr}"
      if addedNames.length > 0
        removedStr = "and #{removedStr}"

    div({className: 'update-users-message'}
      "#{name} #{addedStr} #{removedStr}")

Structural.Components.UpdateUsersMessage = UpdateUsersMessage
