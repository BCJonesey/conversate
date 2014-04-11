class Contact < ActiveRecord::Base
	belongs_to :contact_list, inverse_of: :contacts
	belongs_to :user

	validates :user, uniqueness: { scope: :contact_list}

	def as_json(options={})
		json = super
		json['user'] = self.user.as_json
		return json
	end
end
