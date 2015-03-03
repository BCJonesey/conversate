{div} = React.DOM

AutocompleteOptions = React.createClass
  displayName: 'Autocomplete Options'
  render: ->
    options = _.map @props.options, (opt, idx) =>
      className = 'option'
      if idx == @props.activeIndex
        className += ' active'

      div {
        className: className
        key: opt.id
        onClick: _.partial(@chooseOption, opt)
        onMouseOver: () => @props.setActive(idx)
      }, @props.displayFn(opt)

    className = 'autocomplete-options'
    if options.length == 0
      className += ' autocomplete-options-empty'

    div {className: className}, options

  chooseOption: (option, event) ->
    @props.onSelect(option)

Structural.Components.AutocompleteOptions =
  React.createFactory(AutocompleteOptions)
