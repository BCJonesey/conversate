Conversations = new Meteor.Collection("conversations");

if (Meteor.is_client) {
	
	Template.conversations.conversations = function () {
		return Conversations.find({});
	};
	
	Template.conversations.helpers({
		conversation_name: function() {
			var name = "";
			if (this.users) {
			 	for (var i = 0; i < this.users.length; i++) {
				    if (i > 0) {
						name += ", "
					}
					user = this.users[i];
					name += user;
				}
			}
			return name;
		}
	});
	
	Template.conversations.events({
		'click li.conversation-item': function (event)
		{
			Session.set('conversation',event.currentTarget.id);
		}
	});
	
	get_current_conversation = function () {
		var conversation = Session.get('conversation');
		if (!conversation) {
			conversation = Conversations.insert({});
			Conversations.update(conversation, {$addToSet: {users: get_current_name()}});
			Session.set('conversation', conversation);
		}
		return conversation;
	}
}