{Modal} = Structural.Stores
{OpenModal, ReplaceModalContent} = Structural.Actions
{div} = React.DOM

ModalTrigger = React.createClass
  displayName: 'Modal Trigger'
  mixins: [
    Modal.listenWith('modalUpdate')
  ]

  modalUpdate: ->
    return {
      open: Modal.open()
      active: @state and @state.active and Modal.open()
    }

  componentDidUpdate: (prevProps, prevState) ->
    if @state.active
      _.defer(() => ReplaceModalContent(@props.content, @props.title))
  render: ->
    className = "#{@props.className} #{if @state.active then 'active-trigger' else ''}"
    div {className: className, onClick: @onClick}, @props.children

  onClick: ->
    OpenModal(@props.content, @props.title)
    @setState(active: true)

Structural.Components.ModalTrigger = React.createFactory(ModalTrigger)
