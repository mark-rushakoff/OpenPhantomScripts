require 'rubygems'
require 'minitest/autorun'
require 'spec_helper'

SCRIPT = File.expand_path('../phantom-qunit.js', File.dirname(__FILE__))
QUNIT_BASE = File.expand_path('./vendor/underscore', File.dirname(__FILE__))

assert_has_phantomjs

describe 'phantom-qunit.js' do
  it 'works against the Underscore.js test suite' do
    # currently starting sinatra app manually...
    lines = %x{phantomjs #{SCRIPT} 'http://localhost:4567/test/test.html'}.lines.map(&:chomp)
    $?.exitstatus.must_equal 0
    lines.length.must_equal 4
    # Correct for current specs in Underscore according to submodule SHA
    lines[0].must_equal 'Tests passed: 477'
    lines[1].must_equal 'Tests failed: 0'
    lines[2].must_equal 'Total: 477'
    lines[3].must_match /^Runtime \(ms\): \d+$/
  end
end
