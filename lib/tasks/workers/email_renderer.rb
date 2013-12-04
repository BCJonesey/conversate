module EmailRenderer
  # Text files have trailing newlines, so we don't need one
  # at the start of the separator.
  SEPARATOR = "----------------------------\n"

  def EmailRenderer.render(conversation, current_user)
    relevant_actions = conversation.actions.order('created_at DESC').limit(30)

    rendered = render_participation_header(conversation, current_user);
    relevant_actions.each_index do |idx|
      action = relevant_actions[idx]
      if action.message_type?
        rendered += SEPARATOR
      end

      rendered += render_action(action, current_user)

      next_action = relevant_actions[idx + 1]
      if action.message_type? && next_action && !next_action.message_type?
        rendered += SEPARATOR
      end
    end

    rendered
  end

  def EmailRenderer.render_action(action, current_user)
    render_template(action.type, {:action => action,
                                  :current_user => current_user})
  end

  def EmailRenderer.render_participation_header(conversation, current_user)
    render_template('participation_header', {:conversation => conversation,
                                             :current_user => current_user})
  end

  def EmailRenderer.render_template(template, data)
    # Sneaky trick from http://archive.railsforum.com/viewtopic.php?pid=105722#p105722
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    view.render(:file => "emails/#{template}.text.erb", :locals => data)
  end
end
