# This is here just so AdminHelper#all_models can find it.  Without a model
# class, figuring out exactly how many rows are in a join table in a generic
# way is tricky.
class ConversationsFolder < ActiveRecord::Base
end
