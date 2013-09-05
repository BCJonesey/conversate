module AdminHelper
  def all_models
    Dir[Rails.root.join('app/models/*.rb').to_s].collect do |filename|
      klass = File.basename(filename, '.rb').camelize.constantize
      klass.ancestors.include?(ActiveRecord::Base) ? klass : nil
    end
  end

  def failed_health_tests
    Health.methods(false).map do |m|
      Health.send(m).map { |r| r.merge({:test => m}) }
    end.flatten
  end
end
