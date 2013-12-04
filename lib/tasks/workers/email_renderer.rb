module EmailRenderer
  # Text files have trailing newlines, so we don't need one
  # at the start of the separator.
  SEPARATOR = "----------------------------\n"
  UNWANTED_TYPES = ['update_folders', 'email_delivery_error']

  def EmailRenderer.render(conversation, current_user, format)
    relevant_actions = conversation.actions
                                   .where('type not in (?)', UNWANTED_TYPES)
                                   .order('created_at DESC').limit(30)

    rendered = render_participation_header(conversation, current_user, format);
    relevant_actions.each_index do |idx|
      action = relevant_actions[idx]
      if action.message_type?
        rendered += SEPARATOR
      end

      rendered += render_action(action, current_user, formats)

      next_action = relevant_actions[idx + 1]
      if action.message_type? && next_action && !next_action.message_type?
        rendered += SEPARATOR
      end
    end

    rendered
  end

  def EmailRenderer.render_action(action, current_user, format)
    render_template(format, action.type, {:action => action,
                                          :current_user => current_user})
  end

  def EmailRenderer.render_participation_header(conversation, current_user, format)
    render_template(format, 'participation_header', {:conversation => conversation,
                                                     :current_user => current_user})
  end

  def EmailRenderer.render_template(template, data, format)
    # Sneaky trick from http://archive.railsforum.com/viewtopic.php?pid=105722#p105722
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    view.render(:file => "emails/#{template}.#{format}.erb", :locals => data)
  end
end
