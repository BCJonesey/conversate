{div} = React.DOM

# In chromium at least, the scroll top plus node height is consistently one
# pixel less than the scroll height.
SCROLL_FUDGE = 5

MessagesList = React.createClass
  displayName: 'Messages List'

  componentDidMount: ->
    dom = @getDOMNode()
    dom.scrollTop = dom.scrollHeight
  componentWillUpdate: ->
    dom = @getDOMNode()
    scrollBottom = dom.scrollTop + dom.offsetHeight + SCROLL_FUDGE
    @pinned = scrollBottom >= dom.scrollHeight
  componentDidUpdate: ->
    if @pinned
      dom = @getDOMNode()
      dom.scrollTop = dom.scrollHeight

  getDefaultProps: -> messages: []

  render: ->
    messages = _.map(@props.messages, (message) =>
      Structural.Components.Message(
        message: message,
        currentUser: @props.currentUser
        conversation: @props.conversation
        key: message.id
      )
    )

    div className: 'messages-list',
      messages


Structural.Components.MessagesList = MessagesList
