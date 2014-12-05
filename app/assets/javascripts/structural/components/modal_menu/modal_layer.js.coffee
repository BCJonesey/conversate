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
    title: Modal.title()
  updateModal: ->
    @setState(open: Modal.open(), content: Modal.content(), title: Modal.title())

  render: ->
    {Icon, Button} = Structural.Components

    if @state.open
      div {className: 'modal-screen', ref: 'screen', onClick: @closeOnClickOff},
        div {className: 'modal'},
          div({className: 'modal-title-bar'},
              @state.title,
              Button({action: Structural.Actions.CloseModal}, 'Close')),
          @state.content
    else
      div {className: 'modal-hidden'}

  closeOnClickOff: (event) ->
    if event.target == @refs.screen.getDOMNode()
      Structural.Actions.CloseModal()

Structural.Components.ModalLayer = ModalLayer
