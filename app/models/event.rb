class Event < ActiveRecord::Base
  belongs_to :conversation, :inverse_of => :events
  belongs_to :user, :inverse_of => :events

  attr_accessible :conversation_id, :user_id, :event_type, :data

  before_save do |event|
    event.data = event.json.to_json
  end

  def initialize(params)
    super params
    @json = JSON::load data
  end

  def method_missing(meth, *args, &block)
    meth = meth.to_s
    setter = meth.end_with? '='
    meth = meth[0...-1] if setter
    if @json.has_key? meth
      if setter
        @json[meth] = args[0]
      else
        @json[meth]
      end
    else
      super
    end
  end

  protected
  attr_reader :json
end
