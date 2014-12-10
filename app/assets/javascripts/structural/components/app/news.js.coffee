{div, span, a} = React.DOM

NewsHeader = React.createClass
  displayName: 'News Header'
  render: ->
    div {className: 'news-header'},
      span({className: 'subject'}, @props.children)
      span({className: 'date'}, @props.date)

NewsBlock = React.createClass
  displayName: 'News Block'
  render: ->
    div {className: 'news-block'}, @props.children

News = React.createClass
  displayName: 'News'
  render: ->
    div {className: 'news'},
      NewsHeader({date: 'January'}, 'Brand New Client')
      NewsBlock({}, 'New year, new web client!  Faster, uses less memory,
                     always gets unread counts right, easier for us to work
                     on.  If you\'re into that sort of thing, we\'ve been
                     blogging about some of the stuff we use to build Water
                     Cooler at ',
                     a({href: 'http://structur.al'}, 'http://structur.al'),
                     '.')

Structural.Components.News = News
