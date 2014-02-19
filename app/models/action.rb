class Action < ActiveRecord::Base
  self.inheritance_column = :type_rails
  belongs_to :conversation, :inverse_of => :actions
  belongs_to :user, :inverse_of => :actions

  attr_accessible :conversation_id, :user_id, :type, :data

  validates_presence_of :conversation_id
  validates_presence_of :user_id
  validates_presence_of :type
  validates :type, :inclusion => {
    :in => %w(message email_message deletion retitle update_users update_folders
              move_message update_viewers email_delivery_error)
  }

  DEFAULTS_BY_TYPE = {
    'message' => {'text' => ''},
    'email_message' => {'text' => ''},
    'retitle' => {'title' => ''},
    'update_users' => {'added' => [],
                       'removed' => []},
    'update_folders' => {'added' => [],
                         'removed' => []},
    'update_viewers' => {'added' => [],
                         'removed' => []},
    'email_delivery_error' => {'recipient' => nil,
                               'message' => nil}
  }

  after_initialize do |action|
    action.json = action.data || {}
  end

  before_save do |action|
    action.data = action.json
  end

  def message_type?
    ['message', 'email_message'].include? self.type
  end

  # Public: Access and modify data stored as json in the action record. This will
  # effectively create a slightly different set of fields for each action type.
  #
  # In combination with the before_save callback, lets us use the fields in the
  # data column as though they were actual columns in the database.
  #
  # Examples
  #
  #   e = action.new({:data => {'msg_id': 1, 'text' => 'hello'}.to_json})
  #   e.msg_id
  #   # => 1
  #
  #   e.text = 'goodbye'
  #   e.text
  #   # => 'goodbye'
  #
  #   e = action.new({:data => {'user_id': 1}.to_json})
  #   e.msg_id
  #   # => ArgumentError
  def method_missing(meth, *args, &block)
    if respond_to? meth
      # Catches things like attribute accessors.
      send(meth, *args, &block)
    else

      # Our actual method_missing body. Yay, Rails 4!
      name = meth.to_s
      setter = name.end_with? '='
      name = name[0...-1] if setter

      if !@json.nil? && @json.has_key?(name)
        if setter
          @json[name] = args[0]
        else
          value = @json[name]
          if value.nil? && DEFAULTS_BY_TYPE[self.type].has_key?(name)
            DEFAULTS_BY_TYPE[self.type][name]
          else
            value
          end
        end
      elsif DEFAULTS_BY_TYPE[self.type].has_key?(name)
        DEFAULTS_BY_TYPE[self.type][name]
      end

    end
  end

  def as_json(options)
    json = super(:only => [:id, :type])
    if self.json
      json.merge!(self.json)
    end
    user = User.find(user_id)
    json['user'] = user
    json['timestamp'] = created_at.msec
    return json
  end

  def self.data_for_params(params)
    case params['type']
    when 'message'
      return {
        'text' => params['text']
      }.to_json
    when 'retitle'
      return {
        'title' => params['title']
      }.to_json
    when 'deletion'
      return {
        'msg_id' => params['msg_id']
      }.to_json
    when 'update_users'
      return {
        'added' => params['added'],
        'removed' => params['removed']
      }.to_json
    when 'update_viewers'
      return {
        'added' => params['added'],
        'removed' => params['removed']
      }.to_json
    when 'update_folders'
      return {
        'added' => params['added'],
        'removed' => params['removed'],
        'addedViewers' => calculateAddedViewers(params)
      }.to_json
    end
  end

  def update_data(params)
    self.data = Action::data_for_params(params)
    self.json = data || {}
    save
  end

  protected
  attr_accessor :json

  private
  def self.calculateAddedViewers(params)
    if (! params['prior_conversation_users_and_participants'])
      return []
    end

    conversation = Conversation.find_by_id(params['conversation_id'])
    # The current viewers are the set of users in this conversation, plus the users on all of its current folders,
    # unique. The added viewers are the current viewers plus the set of current viewers with folder changes.
    # Note that it should be impossible to remove users via changes due to the default folder selection.
    return conversation.viewers_and_participants() - params['prior_conversation_users_and_participants']
  end

end
