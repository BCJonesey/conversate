module StructuralHelper
  def json_with_user(o, options={})
    options = options.merge(:user => current_user)
    o.to_json(options).html_safe
  end

  def selected_on_path(target_path)
  	if request.url.include? target_path
      'stb-selected'
    else
      ''
    end
  end
end
