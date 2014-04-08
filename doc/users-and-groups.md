# Creating groups

(Assuming you want the group to have users with ids 3 and 4 in it.)

    pry> g = Group.new(name: 'My Group Name')
    pry> g.users << User.find(3)
    pry> g.users << User.find(4)
    pry> g.save

# Adding an exisiting user to a group

(Assuming you want to add user id 18 to group 25.)

    pry> g = Group.find(25)
    pry> g.users << User.find(18)
    pry> g.save

# Make a user a group admin

(Assuming you want to make user 12 an admin of group 20, and that 12 is already a member of 20.)

    pry> gp = GroupParticipation.where(user_id: 12, group_id: 20).first
    pry> gp.group_admin = true
    pry> gp.save

# Make a user on a fresh database

If you've just wiped your database you don't have any groups to make users through, so you have to assemble at least one through pry.

    pry> u = User.new email: 'alice@example.com', password: 'a'
    pry> u.save

# Set a user to receive email

Set an existing user to receive email when they get a message.

    pry> u = User.find(20)
    pry> u.send_me_mail = true
    pry> u.save
