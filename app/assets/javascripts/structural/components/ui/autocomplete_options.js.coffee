{div} = React.DOM

AutocompleteOptions = React.createClass
  displayName: 'Autocomplete Options'
  render: ->
    options = _.map @props.options, (opt) ->
      div {
        className: 'option'
        onClick: _.partial(@chooseOption, opt)
      }, @props.displayFn(opt)

    div {className: 'autocomplete-options'}, options

  chooseOption: (option, event) ->
    # TODO: A Thing

Structural.Components.AutocompleteOptions =
  React.createFactory(AutocompleteOptions)
