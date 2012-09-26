if (Meteor.is_client) {
	
	Template.nav.current_user = function () {
		return get_current_name();
	};
	
	Template.users.events = {
	    'click input#be': function () {
			set_name();
	    },
	    'keyup input#name': function () {
		if(event.keyCode == 13) {
			set_name();
		}
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

	set_name = function () {
		Session.set('name', $('#name').val());
	}
	
}