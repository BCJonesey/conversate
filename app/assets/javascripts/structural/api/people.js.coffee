{UrlFactory} = Structural.Urls

People = {
  index: Structural.Api.get((user) ->
    UrlFactory.Api.userContactLists(user))
}

Structural.Api.People = People
