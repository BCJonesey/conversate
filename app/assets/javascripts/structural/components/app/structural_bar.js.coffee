{div} = React.DOM

StructuralBar = React.createClass
  displayName: 'Structural Bar'
  render: ->
    div {className: 'structural-bar clearfix'}

Structural.Components.StructuralBar = StructuralBar
