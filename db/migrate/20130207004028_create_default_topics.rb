class CreateDefaultTopics < ActiveRecord::Migration
  def up
    User.all.each do |user|
      topic = Topic.new
      topic.name = 'Conversations'
      topic.save

      user.topics << topic
      user.save

      user.conversations.each do |convo|
        convo.topics << topic
        convo.save
      end
    end
  end

  def down
  end
end
