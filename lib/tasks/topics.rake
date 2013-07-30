namespace :topic do
  namespace :default do
    desc 'Create a default topic for each user that has none'
    task create: [:environment] do
      User.all.each do |user|
        if user.default_topic_id.nil?
          default_topic = Topic.new
          default_topic.name = 'My Conversations'
          default_topic.save
          user.default_topic_id = default_topic.id
          user.topics << default_topic
          user.save
        end
      end
    end

    desc 'Move all conversations into default topics'
    task populate: [:environment] do
      User.all.each do |user|
        default = Topic.find(user.default_topic_id)
        user.conversations.each do |conversation|
          conversation.topics << default
          conversation.save
        end
      end
    end
  end
end
