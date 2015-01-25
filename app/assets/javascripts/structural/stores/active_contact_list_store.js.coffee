{UpdateActiveContactList, UpdateContactLists} = Structural.Actions

ActiveContactList = Hippodrome.createStore
  displayName: 'Active Contact List Store'
  initialize: ->
    @_activeContactListId = null

    @dispatch(UpdateActiveContactList).to(@updateActiveContactList)
    @dispatch(UpdateContactLists)
      .after(Structural.Stores.ContactLists)
      .to(@pickFirstIfNoActive)

  updateActiveContactList: (payload) ->
    @_activeContactListId = payload.contactListId
    @trigger()

  pickFirstIfNoActive: (payload) ->
    if not @_activeContactListId
      activeContactList = Structural.Stores.ContactLists.asList()[0]
      if activeContactList
        @_activeContactListId = activeContactList.id
        @trigger()

  public:
    id: -> @_activeContactListId

Structural.Stores.ActiveContactList = ActiveContactList
