class Contact < ActiveRecord::Base
	belongs_to :contact_list, inverse_of: :contacts
	belongs_to :user

	validates :user, uniqueness: { scope: :contact_list}
end
