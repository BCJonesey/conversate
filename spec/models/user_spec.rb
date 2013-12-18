require 'spec_helper'

describe User do
  describe 'creation:' do
    it 'also creates a default folder' do
      folder_count = Folder.all.length
      user = User.build({email: 'abc@example.com',
                         password: 'a',
                         password_confirmation: 'a'})

      expect(user).to be_a(User)
      expect(user.folders.length).to eq(1)
      expect(user.folders.first.id).to eq(user.default_folder_id)
      expect(Folder.all.length).to eq(folder_count + 1)
    end

    it 'sets send_me_mail for external users' do
      user = User.build(email: 'test@example.com',
                        password: 'a',
                        external: true)
      user.send_me_mail.should be_true
    end

    it 'doesn\t set send_me_mail for regular users' do
      user = User.build(email: 'test@example.com',
                        password: 'a')
      user.send_me_mail.should be_false
    end
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
