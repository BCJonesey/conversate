module AdminHelper
  def all_models
    Dir[Rails.root.join('app/models/*.rb').to_s].collect do |filename|
      klass = File.basename(filename, '.rb').camelize.constantize
      klass.ancestors.include?(ActiveRecord::Base) ? klass : nil
    end
  end
end
