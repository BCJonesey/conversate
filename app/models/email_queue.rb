class EmailQueue < ActiveRecord::Base
  attr_accessible :action_id, :external_user_id

  def EmailQueue.push(message, user)
    EmailQueue.create({
      action_id: message.id,
      external_user_id: user.id
    });
  end
end
