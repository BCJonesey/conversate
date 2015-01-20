{input} = React.DOM

AutocompleteInput = React.createClass
  displayName: 'AutocompleteInput'
  getInitialState: ->
    query: ''
  render: ->
    className = "autocomplete-input #{@props.className}"

    input {
      className: className
      placeholder: @props.placeholder
      value: @state.query
      onChange: @onChange
    }

  onChange: (event) ->
    @setState(query: event.target.value)

Structural.Components.AutocompleteInput = React.createFactory(AutocompleteInput)
