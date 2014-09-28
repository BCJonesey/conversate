ListenToStore = (store, callback) ->
  componentDidMount: ->
    store.listen(this[callback])
  componentWillUnmount: ->
    store.ignore(this[callback])

Structural.Flux.ListenToStore = ListenToStore
