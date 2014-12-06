{CurrentUser} = Structural.Stores
{name} = Structural.Data.Participant
{UrlFactory} = Structural.Urls
{div, span} = React.DOM

StructuralBar = React.createClass
  displayName: 'Structural Bar'
  mixins: [
    CurrentUser.listen('updateUser')
  ]
  getInitialState: ->
    user: CurrentUser.getUser()
  updateUser: ->
    @setState(user: CurrentUser.getUser())

  render: ->
    {BarButton, MenuTrigger} = Structural.Components

    div {className: 'structural-bar'},
      div {className: 'left'},
        BarButton({active: true, icon: 'comment'}, 'Water Cooler'),
        BarButton({icon: 'users'}, 'People'),
        BarButton({href: UrlFactory.tour()}, 'Tour'),
        BarButton({icon: 'dashboard', href: UrlFactory.admin()}, 'Admin'),

      div {className: 'right'},
        MenuTrigger({className: 'news', content: 'Some News Y\'all'},
                    BarButton({icon: 'pied-piper-alt'})),
        span({className: 'stb-text'}, name(@state.user)),
        BarButton({icon: 'search'}),
        BarButton({icon: 'user', href: UrlFactory.profile()}),
        BarButton({icon: 'sign-out', href: UrlFactory.logout()})

Structural.Components.StructuralBar = StructuralBar
