require 'spec_helper'

describe Group do
  describe 'admins can' do
    it 'add users' do
      false.should be_true
    end

    it 'remove users' do
      false.should be_true
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
