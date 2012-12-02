class Event < ActiveRecord::Base
  belongs_to :conversation, :inverse_of => :events
  belongs_to :user, :inverse_of => :events
end
