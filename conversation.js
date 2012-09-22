Conversations = new Meteor.Collection("conversations");

if (Meteor.is_client) {
	
	Template.conversations.conversations = function () {
		return Conversations.find({});
	};
	
	Template.conversations.helpers({
		conversation_name: function() {
			return get_conversation_users(this.users)
		},
		conversation_time: function() {
			var then = moment.unix(this.time);
			return then.format('MMM Do, YYYY h:mmA');
		}
	});
	
	Template.conversations.events({
		'click li.conversation-item': function (event)
		{
			Session.set('conversation',event.currentTarget.id);
		}
	});
	
	get_conversation_users = function (users) {
		var name = "";
		if (users) {
		 	for (var i = 0; i < users.length; i++) {
			    if (i > 0) {
					name += ", "
				}
				user = users[i];
				name += user;
			}
		}
		return name;
	};
	
	get_current_conversation = function () {
		var conversation = Session.get('conversation');
		if (!conversation) {
			conversation = Conversations.insert({time: moment().unix()});
			Conversations.update(conversation, {$addToSet: {users: get_current_name()}});
			Session.set('conversation', conversation);
		}
		return conversation;
	};
}