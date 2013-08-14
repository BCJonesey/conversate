class Group < ActiveRecord::Base
  has_many :group_participations
  has_many :users, :through => :group_participations

  attr_accessible :name

  def admins
    gps = GroupParticipation.where(group_id: self.id, group_admin: true)
    gps.map { |gp| User.find(gp.user_id) }
  end
end
