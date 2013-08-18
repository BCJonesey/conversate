require 'spec_helper'

describe Group do
  describe 'admins can' do
    it 'add users' do
      false.should be_true
    end

    it 'remove users' do
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

      friend_talk = Topic.new(name: 'Friend Talk')
      friend_talk.users += friends.users
      friend_talk.save

      hey_friends = Conversation.new(title: 'Hey Friends')
      hey_friends.users += friends.users
      hey_friends.topics << friend_talk
      hey_friends.save

      work_talk = Topic.new(name: 'Work Talk')
      work_talk.users += coworkers.users
      work_talk.save

      do_some_work = Conversation.new(title: 'Do Some Work')
      do_some_work.users += coworkers.users
      do_some_work.topics << work_talk
      do_some_work.save

      not_fully_removed = coworkers.remove_users([dave.id])

      coworkers.reload
      work_talk.reload
      do_some_work.reload
      dave.reload

      not_fully_removed.empty?.should be_true
      coworkers.users.include?(dave).should be_false
      work_talk.users.include?(dave).should be_false
      do_some_work.users.include?(dave).should be_false
      dave.removed.should be_true

      not_fully_removed = coworkers.remove_users([fletcher.id])

      coworkers.reload
      friends.reload
      work_talk.reload
      friend_talk.reload
      do_some_work.reload
      hey_friends.reload
      fletcher.reload

      not_fully_removed.length.should eq(1)
      not_fully_removed.include?(fletcher).should be_true
      coworkers.users.include?(fletcher).should be_false
      friends.users.include?(fletcher).should be_true
      work_talk.users.include?(fletcher).should be_true
      friend_talk.users.include?(fletcher).should be_true
      do_some_work.users.include?(fletcher).should be_true
      hey_friends.users.include?(fletcher).should be_true
      fletcher.removed.should be_false
    end

    it 'change whether users are admins' do
      alice = build_user 'Alice'
      bob = build_user 'Bob'
      catherine = build_user 'Catherine'

      group = Group.new(name: 'People')
      group.users += [alice, bob, catherine]
      group.save

      group.admins.length.should eq(0)

      group.change_admins([alice.id.to_s])

      group.admins.length.should eq(1)
      group.admins.include?(alice).should be_true

      group.change_admins([alice.id.to_s])

      group.admins.length.should eq(1)
      group.admins.include?(alice).should be_true

      group.change_admins([bob.id.to_s])

      group.admins.length.should eq(1)
      group.admins.include?(bob).should be_true

      group.change_admins([alice.id.to_s, bob.id.to_s])

      group.admins.length.should eq(2)
      group.admins.include?(alice).should be_true
      group.admins.include?(bob).should be_true

      group.change_admins([alice.id.to_s, catherine.id.to_s])

      group.admins.length.should eq(2)
      group.admins.include?(alice).should be_true
      group.admins.include?(catherine).should be_true
    end
  end
end
