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
      onKeyDown: @handleKeys
    }

  onChange: (event) ->
    if @props.onQueryChange
      @props.onQueryChange(event.target.value)

  handleKeys: (event) ->
    if @props.moveActive
      if event.key == 'ArrowUp'
        event.preventDefault()
        @props.moveActive(-1)
      else if event.key == 'ArrowDown'
        event.preventDefault()
        @props.moveActive(1)

    if @props.selectActive
      if event.key == 'Enter' or event.key == 'Tab'
        event.preventDefault()
        @props.selectActive()

Structural.Components.AutocompleteInput = React.createFactory(AutocompleteInput)
