{a} = React.DOM

DROPBOX_REGEX = /www\.dropbox\.com/i

MessageImageLink = React.createClass
  displayName: 'Message Image Link'
  render: ->
    if DROPBOX_REGEX.test(@props.url)
      url = @props.url.replace(DROPBOX_REGEX, 'dl.dropboxusercontent.com')
    else
      url = @props.url

    props =
      className: 'message-image-link'
      href: url
      target: '_blank'
      style:
        backgroundImage: "url(#{url})"

    a(props)

Structural.Components.MessageImageLink = MessageImageLink
