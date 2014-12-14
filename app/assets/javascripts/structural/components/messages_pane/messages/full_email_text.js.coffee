{div} = React.DOM

FullEmailText = React.createClass
  displayName: 'Full Email Text'
  render: ->
    div {className: 'full-email-text-content'},
      @props.message.full_text

Structural.Components.FullEmailText = FullEmailText
