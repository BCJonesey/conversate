{Router} = Structural.Stores
{div} = React.DOM

App = React.createClass
  displayName: 'App'

  mixins: [
    Router.listen('mainView', Router.view)
  ]

  render: ->
    if @state.mainView == 'watercooler'
      mainView = Structural.Components.WaterCooler()
    else if @state.mainView == 'people'
      mainView = Structural.Components.People()

    div {},
      Structural.Components.StructuralBar({
        mainView: @state.mainView
      }),
      mainView,
      Structural.Components.ModalLayer(),
      Structural.Components.MenuLayer()

Structural.Components.App = React.createFactory(App)
