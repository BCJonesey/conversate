{span, i} = React.DOM

IconStack = React.createClass
  displayName: 'Icon Stack'
  render: ->
    classes = ['fa-stack', @props.className]
    className = _.compact(classes).join(' ')

    span {className: className}, @props.children

Structural.Components.IconStack = IconStack
