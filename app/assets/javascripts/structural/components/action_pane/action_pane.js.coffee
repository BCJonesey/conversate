{div} = React.DOM

ActionPane = React.createClass
  displayName: 'Action Pane'
  render: ->
    div {className: 'ui-section act-container'}

Structural.Components.ActionPane = ActionPane
