{arrayToIndexedHash} = Structural.Data.Collection
{name} = Structural.Data.Participant
{div} = React.DOM

Autocomplete = React.createClass
  displayName: 'Autocomplete'

  getInitialState: ->
    return _.merge(@getSifterDictionary(@props), {query: undefined})

  componentWillReceiveProps: (newProps) ->
    @setState(@getSifterDictionary(newProps))

  getSifterDictionary: (props) ->
    blacklist = arrayToIndexedHash(props.blacklist, 'id')
    dictionary = _.reject(props.dictionary, (item) -> !!blacklist[item.id])
    sifter = new Sifter(dictionary)
    return {
      dictionary: dictionary
      sifter: sifter
    }

  render: ->
    {AutocompleteInput, AutocompleteOptions} = Structural.Components

    input = AutocompleteInput {
      placeholder: @props.placeholder
      className: @props.inputClassName
      onQueryChange: @queryChange
      query: @state.query
      ref: 'input'
    }

    if @state.query == undefined or @state.query.length == 0
      optionValues = []
    else
      items = @state.sifter.search(@state.query, {
        fields: ['name', 'email', 'full_name']
        sort: [{field: 'name'}, {field: 'full_name'}, {field: 'email'}]
        filter: true
      }).items

      optionValues = _.map items, (item) =>
        @state.dictionary[item.id]

    options = AutocompleteOptions {
      displayFn: name
      options: optionValues
      onSelect: @optionSelected
      ref: 'options'
    }

    div {className: 'autocomplete'},
      input,
      options

  queryChange: (query) ->
    @setState(query: query)

  optionSelected: (option) ->
    @setState(query: undefined)
    @props.optionSelected(option)

Structural.Components.Autocomplete = React.createFactory(Autocomplete)
