class Action < ActiveRecord::Base
  self.inheritance_column = :type_rails
  belongs_to :conversation, :inverse_of => :actions
  belongs_to :user, :inverse_of => :actions

  attr_accessible :conversation_id, :user_id, :type, :data

  validates_presence_of :conversation_id
  validates_presence_of :user_id
  validates_presence_of :type
  validates :type, :inclusion => {
    :in => %w(message deletion retitle update_users update_folders
              move_message update_viewers)
  }

  after_initialize do |action|
    action.json = JSON::load data || {}
  end

  before_save do |action|
    action.data = action.json.to_json
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
    name = meth.to_s
    setter = name.end_with? '='
    name = name[0...-1] if setter
    if @json != nil && @json.has_key?(name)
      if setter
        @json[name] = args[0]
      else
        @json[name]
      end
    else
      super meth, args, block
    end
  end

  def as_json(options)
    json = super(:only => [:id, :type])
    if self.json
      json.merge!(self.json)
    end
    user = User.find(user_id)
    json['user'] = Hash.new
    json['user']['id'] = user.id
    json['user']['name'] = user.name
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
        'removed' => params['removed']
      }.to_json
    end
  end

  protected
  attr_accessor :json
end
