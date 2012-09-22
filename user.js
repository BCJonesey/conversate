if (Meteor.is_client) {
	
	Template.nav.current_user = function () {
		return get_current_name();
	};
	
	Template.users.events = {
	    'click input#be': function () {
			Session.set('name', $('#name').val());
	    }	
	};
	
	get_current_name = function () {
		var name = Session.get('name');
		if (!name)
		{
			name = 'Anonymous'
			Session.set('name', name);
		}
		return name;
	}
	
}