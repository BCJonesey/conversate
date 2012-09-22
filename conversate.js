Messages = new Meteor.Collection("messages");
Conversations = new Meteor.Collection("conversations");

if (Meteor.is_client) {
  Template.messages.messages = function () {
    return Messages.find({});
  };

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

  Template.nav.current_user = function () {
	return get_current_name();
  };

  send_message = function () {
		id = Messages.insert({text: $('#message-text').val(), from: get_current_name()});
		Conversations.update(get_current_conversation(), {$addToSet: {messages: id, users: get_current_name()}});
		$('#message-text').val('');
  }

  get_current_name = function () {
		var name = Session.get('name');
		if (!name)
		{
			name = 'Anonymous'
			Session.set('name', name);
		}
		return name;
  }

  get_current_conversation = function () {
		var conversation = Session.get('conversation');
		if (!conversation)
		{
			conversation = Conversations.insert({});
			Conversations.update(conversation, {$addToSet: {users: get_current_name()}});
			Session.set('conversation', conversation);
		}
		return conversation;
  }

  Template.messages.helpers({
		message_display: function () {
			return this.text.replace(/\n/g, '<br />');
	  	}
  });
	

  Template.editor.events = {
	'click input#send': function () {
		send_message();
	},
	'click input#nuke': function () {
		Messages.remove({});
		Conversations.remove({});
		Session.set('conversation', null);
	},
	'keyup input#message-text': function () {
		if(event.keyCode == 13) {
			send_message();
		}
	}
  };

  Template.users.events = {
    'click input#be': function () {
		Session.set('name', $('#name').val());
    }	
  };
}

if (Meteor.is_server) {
  Meteor.startup(function () {
  });
}