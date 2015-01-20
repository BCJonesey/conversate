{smallPreview} = Structural.Data.Text
{name} = Structural.Data.Participant
{div} = React.DOM

EmailDeliveryErrorMessage = React.createClass
  displayName: 'Email Delivery Error Message'
  render: ->
    recipient = name(@props.message.recipient)
    user = name(@props.message.user)
    preview = smallPreview(@props.message.message.text)

    message = "Failed to send email to #{recipient} for #{user}'s message \"#{preview}\""
    div {className: 'email-delivery-error-message'}, message

Structural.Components.EmailDeliveryErrorMessage =
  React.createFactory(EmailDeliveryErrorMessage)
