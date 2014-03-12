# This file is used by Rack-based servers to start the application.
require "rack-rewrite"

ENV['WATERCOOLER_SITE_PROTOCOL'] ||= 'http://'
ENV['WATERCOOLER_SITE_URL'] ||= 'localhost'
ENV['WATERCOOLER_SITE_PORT'] ||= ':3000'

use Rack::Rewrite do
  r301 %r{.*}, ENV['WATERCOOLER_SITE_PROTOCOL'] + ENV['WATERCOOLER_SITE_URL'] + ENV['WATERCOOLER_SITE_PORT'] + '$&',
  :if => Proc.new { |rack_env|
  	rack_env['SERVER_NAME'] != ENV['WATERCOOLER_SITE_URL']
  }
end

require ::File.expand_path('../config/environment',  __FILE__)
run Conversate::Application