Messages = new Meteor.Collection("messages");

if (Meteor.is_client) {
  Template.messages.messages = function () {
    return Messages.find({});
  };

  Template.editor.events = {
	'click input#send': function () {
		var name = Session.get('name');
		if (!name)
		{
			name = 'anonymous coward'
		}
		Messages.insert({subject: $('#subject').val(), body: $('#body').val(), from: name});
	},
	'click input#nuke': function () {
		Messages.remove({});
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
		Messages.insert({subject: "Message one", body: "Some random body text.", from: "anonymous coward"});
	}
  });
}