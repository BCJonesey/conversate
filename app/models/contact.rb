class Contact < ActiveRecord::Base
	belongs_to :contact_list, inverse_of: :contacts
	belongs_to :user
end
