# Creating a new folder

(Assuming you want the topic to have users with ids 1 and 5.)

```
pry> t = Topic.new(name: 'My Topic Name')
pry> t.users << User.find(1)
pry> t.users << User.find(5)
pry> t.save
```

Adding participants to a folder

    pry> Topic.all

(A list of all the Topic model objects.)
(Find the id of the one you're looking for.  Assume it's 6.)

    pry> t = Topic.find(6)
    pry> t.users << User.find(8)
    pry> t.save


