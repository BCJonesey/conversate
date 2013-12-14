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
                                    .includes(:user)
  end

  def render(format)
    rendered = ''

    # With two users the participants are obvious - the recpient of the email
    # and the person who wrote the message.
    if conversation.participants.count > 2
      render_participation_header(format)
    end

    actions = @relevant_actions.clone
    # Barring race conditions, this should always be true, since emails are
    # kicked off by messages.
    if actions.first.message_type?
      rendered += render_first_message(actions.first, format)
      actions.delete_at 0
    end

    actions.each_index do |idx|
      action = actions[idx]
      if idx > 0 && action.message_type?
        rendered += render_separator(format)
      end

      rendered += render_action(action, format)

      next_action = actions[idx + 1]
      if action.message_type? && next_action && !next_action.message_type?
        rendered += render_separator(format)
      end
    end

    render_layout(rendered, format)
  end

  private

  def render_action(action, format)
    render_template(format, action.type, {:action => action,
                                          :current_user => @current_user})
  end

  def render_separator(format)
    render_template(format, 'email_section_separator', {})
  end

  def render_first_message(action, format)
    render_template(format, 'first_message', {:action => action,
                                              :current_user => @current_user})
  end

  def render_participation_header(format)
    render_template(format, 'participation_header', {:conversation => @conversation,
                                                     :current_user => @current_user})
  end

  def render_layout(content, format)
    render_template(format, 'layout', {:content => content})
  end

  def render_template(format, template, data)
    # Sneaky trick from http://archive.railsforum.com/viewtopic.php?pid=105722#p105722
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    view.extend EmailHelper
    view.render(:file => "emails/#{template}.#{format}.erb", :locals => data)
  end
end
