    pry> User.all
(A list of all the User models.)
(Find the one you want; assume it's 8.)

    pry> u = User.find(8)
    pry> u.default_topic_id
(Double check that this is nil.  If not, you're dealing with a different bug.)

    pry> u.topics
(A list of all the user's topics.  Find the one named 'My Conversations'; assume it's 37.)

    pry> u.default_topic_id = 37
    pry> u.save
