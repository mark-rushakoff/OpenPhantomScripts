require 'spec_helper'

describe 'phantom-qunit.js (with failing spec)' do
  let(:script) { File.expand_path('../phantom-qunit.js', File.dirname(__FILE__)) }

  def assert_output(lines)
    lines.length.should == 4
    lines[0].should == 'Tests passed: 35'
    lines[1].should == 'Tests failed: 7'
    lines[2].should == 'Total tests:  42'
    lines[3].should match /^Runtime \(ms\): \d+$/
  end

  it 'works against the failing qunit demo' do
    lines = %x{phantomjs #{script} "http://localhost:#{OpenPhantomHelper::PORT}/qunit-fail/test.html"}.lines.map(&:chomp)
    $?.exitstatus.should == 7
    assert_output(lines)
  end

  it_behaves_like 'from local files' do
    let(:absolute_path_to_test_file) { "#{OpenPhantomHelper::VENDOR_BASE}/qunit-fail/test.html" }
    let(:expected_exit_status) { 7 }
  end
end
