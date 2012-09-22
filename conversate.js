Messages = new Meteor.Collection("messages");

if (Meteor.is_client) {
  Template.messages.messages = function () {
    return Messages.find({});
  };

  Template.nav.current_user = function () {
	return get_current_name();
  };

  send_message = function () {
		Messages.insert({text: $('#message-text').val(), from: get_current_name()});
		$('#message-text').val('');
  }

  get_current_name = function () {
		var name = Session.get('name');
		if (!name)
		{
			name = 'Anonymous'
		}
		return name;
  }

  Template.editor.events = {
	'click input#send': function () {
		send_message();
	},
	'click input#nuke': function () {
		Messages.remove({});
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
    if (Messages.find().count() === 0)
	{
		Messages.insert({text: "Some random body text.", from: "Anonymous"});
	}
  });
}