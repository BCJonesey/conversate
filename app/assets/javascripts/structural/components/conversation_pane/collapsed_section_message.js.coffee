{div} = React.DOM

CollapsedSectionMessage = React.createClass
  displayName: 'Collapsed Section Message'
  render: ->
    div {className: 'collapsed-section-message', onClick: @props.onClick},
      "#{@props.conversations.length} #{@props.adjective} conversations"

Structural.Components.CollapsedSectionMessage = CollapsedSectionMessage
