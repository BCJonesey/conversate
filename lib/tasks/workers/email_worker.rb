require 'mandrill'

class EmailWorker
  SLEEP = 5

  def initialize(options={})
    @verbose = !!options[:verbose]
    @exit = false
  end

  def start
    log 'starting'

    trap('TERM') { log 'terminated'; @exit = true }
    trap('INT') { log 'interrupted'; @exit = true }

    loop do
      sleep SLEEP
      break if @exit
    end
  end

  def log(text)
    puts "EMAIL WORKER: #{text}" if @verbose
  end
end
