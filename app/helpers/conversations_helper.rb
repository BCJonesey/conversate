module ConversationsHelper
  def list_item_classes(conversation, opened_conversation, user)
    classes = ['list-item']
    classes << 'highlighted' if conversation == opened_conversation
    classes << 'unread' if conversation.unread_for? user
    classes.join(' ')
  end

  def unread_count_string
    unread_count = logged_in? ? current_user.unread_count : 0
    if unread_count > 0
      "#{unread_count} - "
    else
      ''
    end
  end

  def favicon_tag
    unread = logged_in? && current_user.unread_count > 0
    "<link rel=\"icon\" type=\"image/png\" href=\"/assets/watercooler#{unread ? '-unread' : ''}.png\">".html_safe
  end

  def render_conversation_piece(piece)
    if piece.type == :message
      partial = 'message_piece'
    elsif piece.type == :retitle
      partial = 'retitle_piece'
    elsif piece.type == :deletion
      partial = 'deletion_piece'
    elsif piece.type == :update_users
      partial = 'update_users_piece'
    else
      partial = 'unknown_piece'
    end

    render :partial => "conversations/#{partial}", :locals => { :piece => piece }
  end
end
