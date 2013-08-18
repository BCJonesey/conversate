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

  # Given a list of user ids that should be removed from the group, for each
  # user do one of two things:
  #   - If the user is in this group and only this group, then we can remove
  #     the user from the system entirely.
  #   - If the user is in another group, only remove the user from this group,
  #     and return the user in a list of all such users so that the relevant
  #     admins can contact us for next steps.
  def remove_users(ids)
    users_not_fully_removed = []
    ids.each do |id|
      user = User.find(id)

      if user.groups.length == 1 && user.groups.include?(self)
        user.removed = true
        user.topics.each do |topic|
          topic.users.delete user
          topic.save
        end
        user.conversations.each do |conversation|
          conversation.users.delete user
          conversation.save
        end
      else
        users_not_fully_removed << user
      end

      user.groups.delete self
      user.save
    end

    users_not_fully_removed
  end

  def new_user(params)
    user = User.build(params)
    if user
      user.groups << self
      user.save
    end
    user
  end
end
