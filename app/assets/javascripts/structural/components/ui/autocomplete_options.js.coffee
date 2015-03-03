{div} = React.DOM

AutocompleteOptions = React.createClass
  displayName: 'Autocomplete Options'

  componentDidUpdate: (prevProps, prevState) ->
    dom = @getDOMNode()
    activeElement = dom.getElementsByClassName('active')[0]
    dom.scrollTop = activeElement.offsetTop - (dom.offsetHeight / 2)

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
