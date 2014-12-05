{Modal} = Structural.Stores
{div} = React.DOM

ModalLayer = React.createClass
  displayName: 'Modal Layer'
  mixins: [
    Modal.listen('updateModal')
  ]
  getInitialState: ->
    open: Modal.open()
    content: Modal.content()
  updateModal: ->
    @setState(open: Modal.open(), content: Modal.content())

  render: ->
    if @state.open
      div {className: 'modal-screen'},
        div {className: 'modal'}, @state.content
    else
      div {className: 'modal-hidden'}

Structural.Components.ModalLayer = ModalLayer
