{arrayToIndexedHash} = Structural.Data.Collection
{name} = Structural.Data.Participant
{div} = React.DOM

Autocomplete = React.createClass
  displayName: 'Autocomplete'

  getInitialState: ->
    blacklist = arrayToIndexedHash(@props.blacklist, 'id')
    dictionary = _.reject(@props.dictionary, (item) -> !!blacklist[item.id])
    return {
      blacklist: blacklist
      dictionary: dictionary
      sifter: new Sifter(dictionary)
      query: undefined
    }

  render: ->
    {AutocompleteInput, AutocompleteOptions} = Structural.Components

    input = AutocompleteInput {
      placeholder: @props.placeholder
      className: ''
      onQueryChange: @queryChange
      query: @state.query
      ref: 'input'
    }

    if @state.query == undefined
      optionValues = []
    else
      optionValues = @state.sifter.search(@state.query, {
        fields: ['name', 'email', 'full_name']
        sort: [{field: 'name'}, {field: 'full_name'}, {field: 'email'}]
        filter: true
      })

    options = AutocompleteOptions {
      displayFn: name
      options: optionValues
      onSelect: @optionSelected
      ref: 'options'
    }

    div {className: "autocomplete #{@props.className}"},
      input,
      options

  queryChange: (query) ->
    @setState(query: query)

  optionSelected: (option) ->

Structural.Components.Autocomplete = React.createFactory(Autocomplete)
