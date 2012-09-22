Messages = new Meteor.Collection("messages");

if (Meteor.is_client) {
	
	Template.messages.messages = function () {
		var conversation = Session.get('conversation');
    	return Messages.find({conversation: conversation});
  	};

  	Template.messages.helpers({
			message_display: function () {
				return this.text.replace(/\n/g, '<br />');
		  	}
	});

	send_message = function () {
		id = Messages.insert({text: $('#message-text').val(), from: get_current_name(), conversation: get_current_conversation()});
		Conversations.update(get_current_conversation(), {$addToSet: {users: get_current_name()}});
		$('#message-text').val('');
	}
	
}