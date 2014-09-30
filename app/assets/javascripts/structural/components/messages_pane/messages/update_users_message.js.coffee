{div} = React.DOM

listAsReadableString = (list) ->
  if list.length == 0
    ""
  else if list.length == 1
    list[0]
  else
    "#{list.slice(0, list.length - 1).join(', ')} and #{list[list.length - 1]}"

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

    div({className: 'message update-users-message'}
      "#{name} #{addedStr} #{removedStr}")

Structural.Components.UpdateUsersMessage = UpdateUsersMessage
