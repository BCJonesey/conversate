require 'spec_helper'

describe User do
  describe 'creation:' do
    it 'also creates a default topic' do
      topic_count = Topic.all.length
      user = User.build({email: 'abc@example.com',
                         password: 'a',
                         password_confirmation: 'a'})

      expect(user).to be_a(User)
      expect(user.topics.length).to eq(1)
      expect(Topic.all.length).to eq(topic_count + 1)
    end
  end
end
