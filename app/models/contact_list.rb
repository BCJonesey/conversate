class ContactList < ActiveRecord::Base
	has_many :contacts, inverse_of: :contact_list
	has_many :users, :through => :contacts

	def as_json(options={})
		json = super
		json['contacts'] = self.contacts.as_json
		return json
	end
end
