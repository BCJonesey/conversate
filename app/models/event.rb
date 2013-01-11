class Event < ActiveRecord::Base
  belongs_to :conversation, :inverse_of => :events
  belongs_to :user, :inverse_of => :events

  attr_accessible :conversation_id, :user_id, :event_type, :data

  validates_presence_of :conversation_id
  validates_presence_of :user_id
  validates_presence_of :event_type
  validates :event_type, :inclusion => { :in => %w(message deletion retitle user_update)}

  after_initialize do |event|
    event.json = JSON::load data || {}
  end

  before_save do |event|
    event.data = event.json.to_json
  end

  # Public: Access and modify data stored as json in the event record. This will
  # effectively create a slightly different set of fields for each event type.
  #
  # In combination with the before_save callback, lets us use the fields in the
  # data column as though they were actual columns in the database.
  #
  # Examples
  #
  #   e = Event.new({:data => {'msg_id': 1, 'text' => 'hello'}.to_json})
  #   e.msg_id
  #   # => 1
  #
  #   e.text = 'goodbye'
  #   e.text
  #   # => 'goodbye'
  #
  #   e = Event.new({:data => {'user_id': 1}.to_json})
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

  protected
  attr_accessor :json
end
