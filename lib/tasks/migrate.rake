namespace :migrate do
  namespace :search do
    desc "Compute initial search vectors for actions"
    task actionvectors: [:environment] do
      conn = ActiveRecord::Base.connection
      Action.all.each do |action|
        next unless action.type == 'message'

        text = conn.quote(action.text)
        conn.execute("
          update actions
          set search_vector = to_tsvector('english', #{text})
          where id = #{action.id}
        ")
      end
    end
  end
end
