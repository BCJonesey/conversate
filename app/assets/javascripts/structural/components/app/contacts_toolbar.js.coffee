{div, span} = React.DOM

ContactsToolbar = React.createClass
  displayName: 'Contacts Toolbar'
  render: ->
    if @props.activeContactList
      title = span {className: 'contact-list-title'}, @props.activeContactList.name

    div {className: 'contacts-toolbar'}, title

Structural.Components.ContactsToolbar = React.createFactory(ContactsToolbar)
