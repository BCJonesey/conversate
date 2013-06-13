module StructuralHelper
  def json_with_user(o, options={})
    options = options.merge(:user => current_user)
    o.to_json(options).html_safe
  end
end
