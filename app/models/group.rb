class Group < ActiveRecord::Base
  has_many :group_participations
  has_many :users, :through => :group_participations

  attr_accessible :name

  def admins
    gps = GroupParticipation.where(group_id: self.id, group_admin: true)
    gps.map { |gp| User.find(gp.user_id) }
  end

  # Given a list of user ids who should be admins, make any users who are
  # not admins but are on the list admins, and make any users who are
  # admins but not on the list not admins.
  def change_admins(ids)
    ids.each do |id|
      user = User.find(id)
      unless user.group_admin?(self)
        gp = GroupParticipation.where(user_id: user.id, group_id: self.id).first
        gp.group_admin = true
        gp.save
      end
    end

    self.admins.each do |admin|
      unless ids.include? admin.id.to_s
        gp = GroupParticipation.where(user_id: admin.id, group_id: self.id).first
        gp.group_admin = false
        gp.save
      end
    end
  end
end
