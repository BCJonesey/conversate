module UserHelpers
  def build_user(name)
    User.build(full_name: name,
               email: "#{name}@example.com",
               password: 'a')
  end
end

RSpec.configure do |c|
  c.include UserHelpers
end
