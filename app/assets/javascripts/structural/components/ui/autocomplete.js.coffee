{arrayToIndexedHash} = Structural.Data.Collection
{name} = Structural.Data.Participant
{div} = React.DOM

Autocomplete = React.createClass
  displayName: 'Autocomplete'

  getInitialState: ->
    return _.merge({
      query: undefined
      activeIndex: 0
    }, @getOptions(@props, {}))

  componentWillReceiveProps: (newProps) ->
    @setState(@getOptions(newProps, @state))

  getOptions: (props, state) ->
    blacklist = arrayToIndexedHash(props.blacklist, 'id')
    dictionary = _.reject(props.dictionary, (item) -> !!blacklist[item.id])
    sifter = new Sifter(dictionary)

    if state.query == undefined or state.query.length == 0
      options = []
    else
      items = sifter.search(state.query, {
        fields: ['name', 'email', 'full_name']
        sort: [{field: 'name'}, {field: 'full_name'}, {field: 'email'}]
        filter: true
      }).items

      options = _.map items, (item) -> dictionary[item.id]

    return {
      options: options
    }

  render: ->
    {AutocompleteInput, AutocompleteOptions} = Structural.Components

    input = AutocompleteInput {
      placeholder: @props.placeholder
      className: @props.inputClassName
      onQueryChange: @queryChange
      moveActive: @moveActive
      query: @state.query
      ref: 'input'
    }

    options = AutocompleteOptions {
      displayFn: name
      options: @state.options
      activeIndex: @state.activeIndex
      onSelect: @optionSelected
      setActive: @setActive
      ref: 'options'
    }

    div {className: 'autocomplete'},
      input,
      options

  queryChange: (query) ->
    options = @getOptions(@props, _.merge({}, @state, {query: query})).options

    @setState(query: query, options: options)

  optionSelected: (option) ->
    @setState(query: undefined, activeIndex: 0, options: [])
    @props.optionSelected(option)

  setActive: (idx) ->
    @setState(activeIndex: idx)

  moveActive: (offset) ->
    newIndex = @state.activeIndex + offset
    newIndex = Math.max(0, Math.min(@state.options.length - 1, newIndex))
    @setState(activeIndex: newIndex)

Structural.Components.Autocomplete = React.createFactory(Autocomplete)
