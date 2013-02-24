#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ./routers

var ConversateApp = {
	Models: {},
	Collections: {},
	Views: {},
	Routers: {},
	initialize: function(data, current_user, opened_conversation) {
		var self = this;

		self.current_user = current_user;
		self.opened_conversation = opened_conversation;

		self.conversations = new ConversateApp.Collections.Conversations(data.conversations);

		if (self.opened_conversation) {
			self.messages = new ConversateApp.Collections.Messages(data.messages);
		}

		new ConversateApp.Routers.Conversations({ conversations: self.conversations });
		Backbone.history.start({ pushState: true });

		setInterval(function () {
			console.log('fetch convos');
			self.conversations.fetch();

			// This bit should mimic the behavior of unread_count_string + favicon stuff.
			// Not ideal, but works for now.
			var uc = $('.unread').length;
			if (uc > 0) {
				document.title = uc + ' - Water Cooler'
				$('link[rel="icon"]').attr('href', '/assets/watercooler-unread.png');
			}
			else {
				document.title = 'Water Cooler'
				$('link[rel="icon"]').attr('href','/assets/watercooler.png');
			}

		}, 60000);

		setInterval(function () {
			console.log('fetch messages');

				if (self.opened_conversation) {
					self.messages.fetch({update: true, data: $.param({ id: opened_conversation }) });
				}

		}, 10000);
	}
}
