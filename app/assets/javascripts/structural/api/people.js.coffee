{UrlFactory} = Structural.Urls

People = {
  index: Structural.Api.get((user) ->
    UrlFactory.Api.userContactLists(user))
  contacts: Structural.Api.get((contactList) ->
    UrlFactory.Api.contactListContacts(contactList))
}

Structural.Api.People = People
