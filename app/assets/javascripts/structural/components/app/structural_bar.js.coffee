{CurrentUser} = Structural.Stores
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

    div {className: 'structural-bar'},
      div {className: 'left'},
        BarButton({
          href: UrlFactory.waterCooler(),
          active: true
          icon: 'comment'
        }, 'Water Cooler'),
        BarButton({href: UrlFactory.people(), icon: 'users'}, 'People'),
        BarButton({href: UrlFactory.tour()}, 'Tour'),
        adminButton,

      div {className: 'right'},
        MenuTrigger({
          className: 'news'
          title: 'Water Cooler News'
          content: News()
        }, BarButton({icon: 'pied-piper-alt'})),
        span({className: 'stb-text'}, name(@state.user)),
        BarButton({icon: 'search'}),
        BarButton({icon: 'user', href: UrlFactory.profile()}),
        BarButton({icon: 'sign-out', href: UrlFactory.logout()})

Structural.Components.StructuralBar = StructuralBar
