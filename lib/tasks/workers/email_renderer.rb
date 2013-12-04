class EmailRenderer
  UNWANTED_TYPES = ['update_folders', 'email_delivery_error']

  attr_reader :conversation, :current_user

  def initialize(conversation, current_user)
    @conversation = conversation
    @current_user = current_user
    @relevant_actions = conversation.actions
                                    .where('type not in (?)', UNWANTED_TYPES)
                                    .order('created_at DESC')
                                    .limit(30)
  end

  def render(format)
    rendered = render_participation_header(format)
    @relevant_actions.each_index do |idx|
      action = @relevant_actions[idx]
      if action.message_type?
        rendered += render_separator(format)
      end

      rendered += render_action(action, format)

      next_action = @relevant_actions[idx + 1]
      if action.message_type? && next_action && !next_action.message_type?
        rendered += render_separator(format)
      end
    end
    rendered
  end

  private

  def render_action(action, format)
    render_template(format, action.type, {:action => action,
                                          :current_user => @current_user})
  end

  def render_separator(format)
    render_template(format, 'email_section_separator', {})
  end

  def render_participation_header(format)
    render_template(format, 'participation_header', {:conversation => @conversation,
                                                     :current_user => @current_user})
  end

  def render_template(format, template, data)
    # Sneaky trick from http://archive.railsforum.com/viewtopic.php?pid=105722#p105722
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    view.render(:file => "emails/#{template}.#{format}.erb", :locals => data)
  end
end
