{div} = React.DOM

ActionPane = React.createClass
  displayName: 'Action Pane'
  render: ->
    div {className: 'ui-section act-container'},
      Structural.Components.ConversationEditorBar()
      Structural.Components.ParticipantsEditorBar()
      Structural.Components.ActionList()
      Structural.Components.Compose()

Structural.Components.ActionPane = ActionPane
