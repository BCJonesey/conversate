module StructuralHelper
  def json_with_user(o)
    o.to_json(:user => current_user).html_safe
  end
end
