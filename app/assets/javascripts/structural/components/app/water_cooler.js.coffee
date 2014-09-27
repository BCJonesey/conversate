{div} = React.DOM

WaterCooler = React.createClass
  displayName: 'Water Cooler'
  render: ->
    div {className: 'water-cooler'},
      Structural.Components.FolderPane(),
      Structural.Components.ConversationPane(),
      Structural.Components.ActionPane()

Structural.Components.WaterCooler = WaterCooler
