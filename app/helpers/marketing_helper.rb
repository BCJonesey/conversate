module MarketingHelper
  def active_on_path(target_path)
    'active' if request.url.include? target_path
  end
end