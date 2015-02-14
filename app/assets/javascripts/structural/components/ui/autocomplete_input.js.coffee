{input} = React.DOM

AutocompleteInput = React.createClass
  displayName: 'AutocompleteInput'
  render: ->
    className = "autocomplete-input #{@props.className}"

    input {
      className: className
      placeholder: @props.placeholder
      value: if @props.query then @props.query else ''
      onChange: @onChange
    }

  onChange: (event) ->
    if @props.onQueryChange
      @props.onQueryChange(event.target.value)

Structural.Components.AutocompleteInput = React.createFactory(AutocompleteInput)
