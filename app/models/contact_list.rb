class ContactList < ActiveRecord::Base
  has_many :contacts, inverse_of: :contact_list
  has_many :users, :through => :contacts
  has_many :participants, as: :participatable

  validates :name, length: { minimum: 2 }

	def as_json(options={})
		json = super
		json['contacts'] = self.contacts.as_json
    json['participants'] = self.participants.includes(:user).map{|p| p.user}
		return json
	end
end
