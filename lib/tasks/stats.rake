namespace :stats do
  desc 'Basic statistics about a group.'
  task :group, [:group, :omit_1, :omit_2, :omit_3] => [:environment] do |t, args|
    group = Group.find_by_name(args[:group])
    omits = [args[:omit_1], args[:omit_2], args[:omit_3]]
              .compact
              .map {|name| User.find_by_full_name(name) }

    puts group
    puts omits
  end
end
