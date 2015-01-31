{CurrentUser, Folders} = Structural.Stores
{name} = Structural.Data.Participant
{UrlFactory} = Structural.Urls
{div, span} = React.DOM

StructuralBar = React.createClass
  displayName: 'Structural Bar'
  mixins: [
    CurrentUser.listen('user', CurrentUser.getUser)
  ]

  render: ->
    {BarButton, MenuTrigger, News} = Structural.Components

    if @state.user and @state.user.site_admin
      adminButton = BarButton({icon: 'dashboard', href: UrlFactory.admin()}, 'Admin')

    firstFolder = _.first(Folders.asList())
    if firstFolder
      firstFolderId = firstFolder.id

    div {className: 'structural-bar'},
      div {className: 'left'},
        BarButton({
          href: UrlFactory.waterCooler()
          active: @props.mainView == 'watercooler'
          icon: 'comment'
          action: Structural.Actions.UpdateActiveFolder
          actionArgs: [firstFolderId]
        }, 'Water Cooler'),
        BarButton({
          href: UrlFactory.people()
          active: @props.mainView == 'people'
          icon: 'users'
          action: Structural.Actions.UpdateActiveContactList
          actionArgs: []
        }, 'People'),
        BarButton({href: UrlFactory.tour()}, 'Tour'),
        adminButton,

      div {className: 'right'},
        MenuTrigger({
          className: 'news'
          title: 'Water Cooler News'
          content: News()
        }, BarButton({icon: 'pied-piper-alt'})),
        span({className: 'stb-text'}, name(@state.user)),
        MenuTrigger({
          className: 'search'
          title: 'Search'
          content: News()
        }, BarButton({icon: 'search'})),
        BarButton({icon: 'user', href: UrlFactory.profile()}),
        BarButton({icon: 'sign-out', href: UrlFactory.logout()})

Structural.Components.StructuralBar = React.createFactory(StructuralBar)
