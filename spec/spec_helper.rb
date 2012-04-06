require 'rubygems'
require 'webrick'
require 'net/http'
require 'rspec'

VENDOR_BASE = File.expand_path('./vendor/', File.dirname(__FILE__))

def assert_has_phantomjs
  raise 'Could not locate phantomjs binary!' unless system('which phantomjs')
end

def start_server
  fork do
    server = WEBrick::HTTPServer.new(:Port => 5678, :DocumentRoot => VENDOR_BASE)
    %w{INT TERM}.each do |signal|
      trap(signal) { server.shutdown }
    end
    server.start
  end
end

def ensure_server_started
  could_connect = false
  uri = URI("http://localhost:5678/")
  i = 0
  max = 20
  while i < max do
    begin
      res = Net::HTTP.get_response(uri)
      could_connect = true
      break
    rescue Errno::ECONNREFUSED
      puts 'Connection refused!'
      sleep 1
    end
    i += 1
  end
  raise "Could not ever connect to server" unless could_connect
end

RSpec.configure do |config|
  config.before(:all) do
    assert_has_phantomjs
    server_pid = start_server
    at_exit do
      Process.kill('TERM', server_pid)
    end
    ensure_server_started
  end
end
