module ConversationsHelper
  def list_item_classes(conversation, opened_conversation, user)
    classes = ['list-item']
    classes << 'highlighted' if conversation == opened_conversation
    classes << 'unread' if conversation.unread_for? user
    classes.join(' ')
  end
end
