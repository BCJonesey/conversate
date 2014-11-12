{i} = React.DOM

Icon = React.createClass
  displayName: 'icon'
  render: ->
    classes = ['fa', "fa-#{@props.name}", @props.className]
    className = _.compact(classes).join(' ')
    i {className: className}

Structural.Components.Icon = Icon
