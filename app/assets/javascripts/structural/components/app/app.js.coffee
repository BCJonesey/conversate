{div} = React.DOM

App = React.createClass
  displayName: 'App'
  render: ->
    div {},
      Structural.Components.StructuralBar(),
      Structural.Components.WaterCooler(),
      Structural.Components.ModalLayer()

Structural.Components.App = App
