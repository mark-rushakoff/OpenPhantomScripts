require 'spec_helper'

describe 'phantom-jasmine.js (skip+fail)' do
  let(:script) { File.expand_path('../phantom-jasmine.js', File.dirname(__FILE__)) }
  let(:expected_exit_status) { 1 }

  def assert_output(lines)
    lines.length.should == 5
    lines[0].should == 'Tests passed:  1'
    lines[1].should == 'Tests skipped: 5'
    lines[2].should == 'Tests failed:  1'
    lines[3].should == 'Total tests:   7'
    lines[4].should match /^Runtime \(ms\):  \d+$/
  end

  it 'works against the skip+fail Jasmine test suite' do
    lines = %x{phantomjs #{script} "http://localhost:#{OpenPhantomHelper::PORT}/jasmine-skip-fail/test.html?spec=Player%20f"}.lines.map(&:chomp)
    $?.exitstatus.should == 1
    assert_output(lines)
  end

  it_behaves_like 'from local files' do
    let(:absolute_path_to_test_file) { "#{OpenPhantomHelper::VENDOR_BASE}/jasmine-skip-fail/test.html?spec=Player%20f" }
  end
end
