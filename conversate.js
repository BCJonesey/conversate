Messages = new Meteor.Collection("messages");

if (Meteor.is_client) {
  Template.messages.messages = function () {
    return Messages.find({}, {sort: {subject: 1}});
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