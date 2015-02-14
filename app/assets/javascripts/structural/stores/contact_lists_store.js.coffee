{name} = Structural.Data.Participant
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

  contactName: (contact) ->
    name(contact.user)

  public:
    byId: (id) ->
      @_contactLists[id]
    asList: ->
      hashToSortedArray(@_contactLists, 'id')

    alphabeticalContacts: (contactListId) ->
      hashToSortedArray(@_contactLists[contactListId].contacts, @contactName)
    allUsers: () ->
      _.uniq(_.union(_.map(_.values(@_contactLists), 'contacts')), false, 'id')

Structural.Stores.ContactLists = ContactLists
