module ApplicationHelper
  def selected_if_path(prefix)
    request.path.start_with?(prefix) ? 'is-selected' : ''
  end
end
