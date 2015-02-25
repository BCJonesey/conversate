{div} = React.DOM

AutocompleteOptions = React.createClass
  displayName: 'Autocomplete Options'
  render: ->
    options = _.map @props.options, (opt) =>
      div {
        className: 'option'
        onClick: _.partial(@chooseOption, opt)
        key: opt.id
      }, @props.displayFn(opt)

    className = 'autocomplete-options'
    if options.length == 0
      className += ' autocomplete-options-empty'

    div {className: className}, options

  chooseOption: (option, event) ->
    @props.onSelect(option)

Structural.Components.AutocompleteOptions =
  React.createFactory(AutocompleteOptions)
