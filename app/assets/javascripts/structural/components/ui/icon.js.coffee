{i} = React.DOM

Icon = React.createClass
  displayName: 'icon'
  render: ->
    classes = ['fa', "fa-#{@props.name}", @props.className]
    if @props.stack
      classes.push("fa-stack-#{@props.stack}x")

    if @props.inverse
      classes.push('fa-inverse')

    if @props.spin
      classes.push('fa-spin')

    className = _.compact(classes).join(' ')
    i {className: className}

Structural.Components.Icon = Icon
