{div} = React.DOM

ActionList = React.createClass
  displayName: 'Action List'
  render: ->
    div {className: 'act-list ui-scrollable'}

Structural.Components.ActionList = ActionList
