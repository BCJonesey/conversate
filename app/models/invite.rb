class Invite < ActiveRecord::Base
    validates :email, presence: true, format: /@/
end
