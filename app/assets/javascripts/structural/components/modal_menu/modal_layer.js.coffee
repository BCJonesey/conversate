{Modal} = Structural.Stores
{div} = React.DOM

ModalLayer = React.createClass
  displayName: 'Modal Layer'
  mixins: [
    Modal.listen('open', Modal.open)
  ]

  render: ->
    {IconButton} = Structural.Components

    if @state.open
      div {className: 'modal-screen', ref: 'screen', onClick: @closeOnClickOff},
        div {className: 'modal'},
          div({className: 'modal-title-bar'},
              Modal.title(),
              IconButton({action: Structural.Actions.CloseModal, icon: 'times'})),
          Modal.content()
    else
      div {className: 'modal-hidden'}

  closeOnClickOff: (event) ->
    if event.target == @refs.screen.getDOMNode()
      Structural.Actions.CloseModal()

Structural.Components.ModalLayer = React.createFactory(ModalLayer)
