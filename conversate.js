if (Meteor.is_client) {
	
	Template.editor.events = {
	'click input#send': function () {
		send_message();
	},
	'keyup input#message-text': function () {
		if(event.keyCode == 13) {
			send_message();
		}
	}	
 	};

	Template.page.helpers({
	'has_user': function () {
		var user = Session.get('name');
		if (user)
		{
			return true;
		}
		return false;
	}
	});

	Template.nav.events({
	'click .nav-signout': function () {
		Session.set('name', null);
	},
	'click #nuke': function () {
		Messages.remove({});
		Conversations.remove({});
		Session.set('conversation', null);
	}
	});

}

if (Meteor.is_server) {
	
  Meteor.startup(function () {
  });

}