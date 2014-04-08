# Opening a PRY console on production

If you haven't interacted with Heroku on your current machine before, you probably need the Heroku Toolbelt: https://toolbelt.heroku.com

    $ cd ~/Projects/watercooler
(Or wherever you keep the code.)

    $ heroku run rails c -a water-cooler
(A bunch of Heroku info...)

    pry>

To exit pry, use Ctrl-D (or Cmd-D on OSX).  https://en.wikipedia.org/wiki/End-of-transmission_character

# Finding a particular model when you don't know it's ID

(First, figure out what kind of object you're looking for.  It's probably a user, conversation, topic, or group.  Maybe an action?)

(If there are relatively few instances of the class [like users and groups], you can try scanning through all of them to pick out the one you want.)

```
pry> User.all
[#<User id: 2, email: "will.lubelski@gmail.com",   crypted_password: "$2a$10$eLhEolDGKBc6tOQu2Iq10uKZXQCiPiHYYq0.yyNkZZF5...", salt: "qNiepyUSm7PtAxLiRymv", created_at: "2012-12-29 02:48:31", updated_at: "2013-08-07 17:36:30", remember_me_token: nil, remember_me_token_expires_at: nil, full_name: "William Lubelski", is_admin: true, invited_by: nil, default_topic_id: 52>]
```

(This will spit out a list of user records that each look like that.  It's easiest to kind of unfocus your eyes and just scan for the information you're looking for - an email or name or whatever - and once you find it, look backwards for the id.)

(If there are a lot of instances of the object [like conversations or actions]), it'll help to know one of the other fields.)

    pry> Conversation.where(title: 'Structural Lobby 10.1')
(This will spit out a similar list of objects, but hopefully few enough that you can scan for the right one.)

(If you only know part of a string field, like title or name, you can try this)

    pry> Action.where('text like ?', 'javascript sucks!')
(If there are any actions that have that as a substring [note that it's a strict string match, so capitalization and punctuation and everything matter] they'll appear here.)

# Useful IDs to know

- Sean is user id 1
- Will is user id 2
- Nick is user id 3


