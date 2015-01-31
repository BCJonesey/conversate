{div, span} = React.DOM

ContactsHeaders = React.createClass
  displayName: 'Contacts Headers'
  render: ->
    div {className: 'contacts-headers'},
      span({className: 'header'}, 'Name')
      span({className: 'header'}, 'Email')

Structural.Components.ContactsHeaders = React.createFactory(ContactsHeaders)
