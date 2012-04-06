require 'rubygems'
require 'webrick'
require 'net/http'
require 'rspec'

module OpsHelper
  VENDOR_BASE = File.expand_path('./vendor/', File.dirname(__FILE__))
  PORT = 5678

  class << self
    def assert_has_phantomjs
      raise 'Could not locate phantomjs binary!' unless system('which phantomjs')
    end

    def start_server
      fork do
        server = WEBrick::HTTPServer.new(:Port => PORT, :DocumentRoot => VENDOR_BASE)
        %w{INT TERM}.each do |signal|
          trap(signal) { server.shutdown }
        end
        server.start
      end
    end

    def ensure_server_started
      could_connect = false
      uri = URI("http://localhost:#{PORT}/")
      i = 0
      max = 20
      while i < max do
        begin
          res = Net::HTTP.get_response(uri)
          could_connect = true
          break
        rescue Errno::ECONNREFUSED
          sleep 1
        end
        i += 1
      end

      raise "Could not ever connect to server" unless could_connect
    end
  end
end

RSpec.configure do |config|
  config.before(:all) do
    OpsHelper::assert_has_phantomjs
    server_pid = OpsHelper::start_server
    at_exit do
      Process.kill('TERM', server_pid)
    end
    OpsHelper::ensure_server_started
  end
end
