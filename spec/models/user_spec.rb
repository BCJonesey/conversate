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
      expect(user.topics.first.id).to eq(user.default_topic_id)
      expect(Topic.all.length).to eq(topic_count + 1)
    end
  end

  def build_user(name)
    User.build(full_name: name,
               email: "#{name}@example.com",
               password: 'a')
  end

  describe 'address books' do
    it 'only contains users that share a group' do
      alice = build_user 'Alice'
      bob = build_user 'Bob'
      catherine = build_user 'Catherine'
      dave = build_user 'Dave'
      eliza = build_user 'Eliza'
      fletcher = build_user 'Fletcher'

      friends = Group.new(name: 'Friends')
      friends.users += [alice, bob, eliza, fletcher]
      friends.save

      coworkers = Group.new(name: 'Coworkers')
      coworkers.users += [alice, dave, catherine, fletcher]
      coworkers.save

      bob.address_book.index{ |u| u['id'] == alice.id }.should be_true
      bob.address_book.index{ |u| u['id'] == eliza.id }.should be_true
      bob.address_book.index{ |u| u['id'] == fletcher.id }.should be_true
      bob.address_book.length.should eq(3)

      fletcher.address_book.index{ |u| u['id'] == alice.id }.should be_true
      fletcher.address_book.index{ |u| u['id'] == bob.id }.should be_true
      fletcher.address_book.index{ |u| u['id'] == catherine.id }.should be_true
      fletcher.address_book.index{ |u| u['id'] == dave.id }.should be_true
      fletcher.address_book.index{ |u| u['id'] == eliza.id }.should be_true
      fletcher.address_book.index{ |u| u['id'] == fletcher.id }.should be_nil
    end
  end
end
