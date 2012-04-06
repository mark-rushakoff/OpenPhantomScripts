require 'rubygems'
require 'webrick'
require 'net/http'

require 'bundler'
Bundler.require(:default, :development)

module OpenPhantomHelper
  VENDOR_BASE = File.expand_path('./vendor/', File.dirname(__FILE__))
  PORT = 5678

  class << self
    def start_server_once
      return if @started
      @started = true
      assert_has_phantomjs
      server_pid = start_server
      ensure_server_started
      at_exit do
        Process.kill('TERM', server_pid)
      end
    end

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

shared_examples_for 'correct failures' do
  it 'fails when no url is given' do
    %x{phantomjs #{script}}
    $?.exitstatus.should == 1
  end
end

shared_examples_for 'from local files' do
  it 'can read files off disk' do
    lines = %x{phantomjs #{script} file://#{absolute_path_to_test_file}}.lines.map(&:chomp)
    $?.exitstatus.should == 0
    assert_output(lines)
  end
end
