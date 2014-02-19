class ContactList < ActiveRecord::Base
	has_many :contacts, inverse_of: :contact_list
	has_many :users, :through => :contacts
end
