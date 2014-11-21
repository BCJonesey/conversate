{div} = React.DOM

StructuralBar = React.createClass
  displayName: 'Structural Bar'
  render: ->
    {BarButton} = Structural.Components

    div {className: 'structural-bar'},
      BarButton({active: true, icon: 'comment'}, 'Water Cooler'),
      BarButton({icon: 'users'}, 'People'),
      BarButton({}, 'Tour'),
      BarButton({icon: 'dashboard'}, 'Admin')

Structural.Components.StructuralBar = StructuralBar
