Messages = new Meteor.Collection("messages");

if (Meteor.is_client) {
  Template.messages.messages = function () {
    return Messages.find({});
  };

  Template.editor.events = {
	'click input#send': function () {
		Messages.insert({subject: $('#subject').val(), body: $('#body').val()});
	},
	'click input#nuke': function () {
		Messages.remove({});
	}
  };
}

if (Meteor.is_server) {
  Meteor.startup(function () {
    if (Messages.find().count() === 0)
	{
		Messages.insert({subject: "Message one", body: "Some random body text."});
	}
  });
}