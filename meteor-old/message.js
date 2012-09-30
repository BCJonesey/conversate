Messages = new Meteor.Collection("messages");

if (Meteor.is_client) {
	
	Template.messages.messages = function () {
		var conversation = Session.get('conversation');
    		return Messages.find({conversation: conversation});
  	};

  	Template.messages.helpers({
			message_display: function () {
				return this.text.replace(/\n/g, '<br />');
		  	},
			conversants_display: function () {
				var conversation_id = Session.get('conversation');
				if (conversation_id) {
					var conversation = Conversations.findOne({_id: conversation_id});
					if (conversation) {
						var users = conversation.users;
						var displayString = 'Conversation with ' + users[0];
						if (users.length > 1) {
							for (var i = 1; i < users.length - 1; i++) {
								var user = users[i];
								displayString += ', ' + users[i];
							}
							displayString += ' and ' + users[users.length - 1];	
						}
						return displayString;
					}
				}
			}
	});


	send_message = function () {
		var text = $('#message-text').val();
		id = Messages.insert({text: text, from: get_current_name(), conversation: get_current_conversation()});
		Conversations.update(get_current_conversation(), {$addToSet: {users: get_current_name()}});
		$('#message-text').val('');
	}
	
}