class AddConversationsToDefaultTopic < ActiveRecord::Migration
  class User < ActiveRecord::Base
    has_many :reading_logs
  end

  class Topic < ActiveRecord::Base
  end

  class ReadingLog < ActiveRecord::Base
  end

  def change
    User.all.each do |user|
      topic = Topic.new
      topic.name = 'Conversations'
      topic.save

      user.reading_logs.each do |log|
        log.topic_id = topic.id
        log.save
      end
    end
  end
end
