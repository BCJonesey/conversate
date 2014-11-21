{CurrentUser} = Structural.Stores
{name} = Structural.Data.Participant
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
    {BarButton} = Structural.Components

    div {className: 'structural-bar'},
      div {className: 'left'},
        BarButton({active: true, icon: 'comment'}, 'Water Cooler'),
        BarButton({icon: 'users'}, 'People'),
        BarButton({}, 'Tour'),
        BarButton({icon: 'dashboard'}, 'Admin'),

      div {className: 'right'},
        BarButton({icon: 'pied-piper-alt'}),
        span({className: 'stb-text'}, name(@state.user)),
        BarButton({icon: 'search'}),
        BarButton({icon: 'user'}),
        BarButton({icon: 'sign-out'})

Structural.Components.StructuralBar = StructuralBar
