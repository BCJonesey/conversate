{Modal} = Structural.Stores
{div} = React.DOM

ModalTrigger = React.createClass
  displayName: 'Modal Trigger'
  mixins: [
    Modal.listen('modalUpdate')
  ]
  getInitialState: ->
    active: false
    open: Modal.open()
  modalUpdate: ->
    @setState(open: Modal.open(), active: @state.active and Modal.open())
  render: ->
    className = "#{@props.className} #{if @state.active then 'active-trigger' else ''}"
    div {className: className, onClick: @onClick}, @props.children

  onClick: ->
    Structural.Actions.OpenModal(@props.content, @props.title)
    @setState(active: true)

Structural.Components.ModalTrigger = ModalTrigger
