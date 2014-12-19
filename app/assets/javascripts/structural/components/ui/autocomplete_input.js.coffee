{input} = React.DOM

AutocompleteInput = React.createClass
  displayName: 'AutocompleteInput'
  render: ->
    className = "autocomplete-input #{@props.className}"
    input {className: className, placeholder: @props.placeholder}

Structural.Components.AutocompleteInput = AutocompleteInput
