require 'ruby-prof'

namespace :profile do
  desc 'Profiles the json for a user\'s conversations'
  task conversations: [:environment] do
    u = User.find(1)
    t = Folder.find(u.default_folder_id)

    result = RubyProf.profile do
      t.conversations.to_json(:user => u)
    end

    printer = RubyProf::CallStackPrinter.new(result)
    printer.print(File.new(Rails.root.join('log/profile_conversations.html'), 'w'))
  end
end
