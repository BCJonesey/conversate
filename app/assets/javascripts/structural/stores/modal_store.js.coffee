Modal = Hippodrome.createStore
  displayName: 'Modal Store'
  initialize: ->
    @_open = false
    @_content = undefined
    @_title = undefined

    @dispatch(Structural.Actions.OpenModal).to(@openModal)
    @dispatch(Structural.Actions.ReplaceModalContent).to(@replaceModal)
    @dispatch(Structural.Actions.CloseModal).to(@closeModal)

  openModal: (payload) ->
    @_open = true
    @_content = payload.content
    @_title = payload.title
    @trigger()
  replaceModal: (payload) ->
    if @_open
      @_content = payload.content
      @trigger()
  closeModal: (payload) ->
    @_open = false
    @_content = undefined
    @_title = undefined
    @trigger()

  public:
    open: () -> @_open
    content: () -> @_content
    title: () -> @_title

Structural.Stores.Modal = Modal
