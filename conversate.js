if (Meteor.is_client) {
	
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

}

if (Meteor.is_server) {
	
  Meteor.startup(function () {
  });

}