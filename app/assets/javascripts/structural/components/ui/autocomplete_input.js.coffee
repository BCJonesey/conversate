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
      onKeyDown: @moveActive
    }

  onChange: (event) ->
    if @props.onQueryChange
      @props.onQueryChange(event.target.value)

  moveActive: (event) ->
    if @props.moveActive
      if event.key == 'ArrowUp'
        event.preventDefault()
        @props.moveActive(-1)
      else if event.key == 'ArrowDown'
        event.preventDefault()
        @props.moveActive(1)

Structural.Components.AutocompleteInput = React.createFactory(AutocompleteInput)
