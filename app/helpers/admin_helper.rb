module AdminHelper
  def all_database_models
    Dir[Rails.root.join('app/models/*.rb').to_s].collect do |filename|
      klass = File.basename(filename, '.rb').camelize.constantize
      klass.ancestors.include?(ActiveRecord::Base) ? klass : nil
    end.compact
  end

  def health_tests
    Health.methods(false)
  end

  def failed_health_tests
    health_tests.map do |m|
      Health.send(m).map { |r| r.merge({:test => m}) }
    end.flatten
  end

  def test_s(name, capitalize=false)
    sentence = name.to_s.gsub('_', ' ')
    capitalize ? sentence.capitalize : sentence
  end
end
