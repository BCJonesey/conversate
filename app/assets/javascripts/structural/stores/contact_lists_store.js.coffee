{hashToSortedArray} = Structural.Data.Collection

ContactLists = Hippodrome.createStore
  displayName: 'Contact Lists'
  initialize: ->
    @_contactLists = {}

    @dispatch(Structural.Actions.UpdateContactLists)
      .to(@updateContactLists)

  updateContactLists: (payload) ->
    @_contactLists = payload.contactLists
    @trigger()

  public:
    byId: (id) ->
      @_contactLists[id]
    asList: ->
      hashToSortedArray(@_contactLists, 'id')


Structural.Stores.ContactLists = ContactLists
