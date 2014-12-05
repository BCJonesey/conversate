{div} = React.DOM

ModalTrigger = React.createClass
  displayName: 'Modal Trigger'
  render: ->
    div {className: @props.className, onClick: @onClick}, @props.children

  onClick: ->
    Structural.Actions.OpenModal(@props.content, @props.title)

Structural.Components.ModalTrigger = ModalTrigger
