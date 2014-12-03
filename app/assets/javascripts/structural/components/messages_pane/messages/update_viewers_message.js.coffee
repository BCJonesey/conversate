{listAsReadableString} = Structural.Data.English
{name} = Structural.Data.Participant
{div} = React.DOM

UpdateViewersMessage = React.createClass
  displayName: 'Update Viewers Message'
  render: ->
    addedNames = _.map(@props.message.added, name)
    removedNames = _.map(@props.message.removed, name)

    addedStr = listAsReadableString(addedNames)
    removedStr = listAsReadableString(removedNames)
    userName = name(@props.message.user)

    if addedNames.length > 0
      addedStr = "added #{addedStr} as a viewer"

    if removedNames.length > 0
      removedStr = "removed #{removedStr} as a viewer"
      if addedNames.length > 0
        removedStr = "and #{removedStr}"

    div {className: 'update-viewers-message'},
      "#{userName} #{addedStr} #{removedStr}"

Structural.Components.UpdateViewersMessage = UpdateViewersMessage
