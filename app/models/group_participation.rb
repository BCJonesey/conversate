class GroupParticipation < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  attr_accessible
end
