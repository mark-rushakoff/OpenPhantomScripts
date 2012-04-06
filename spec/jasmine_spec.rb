require 'spec_helper'

describe 'phantom-jasmine.js' do
  let(:script) { File.expand_path('../phantom-jasmine.js', File.dirname(__FILE__)) }

  def assert_output(lines)
    lines.length.should == 5
    lines[0].should == 'Tests passed:  5'
    lines[1].should == 'Tests skipped: 0'
    lines[2].should == 'Tests failed:  0'
    lines[3].should == 'Total tests:   5'
    lines[4].should match /^Runtime \(ms\):  \d+$/
  end

  it 'works against the sample Jasmine test suite' do
    lines = %x{phantomjs #{script} "http://localhost:#{OpsHelper::PORT}/jasmine-simple-example/test.html"}.lines.map(&:chomp)
    $?.exitstatus.should == 0
    assert_output(lines)
  end

  it_behaves_like 'correct failures'

  it_behaves_like 'from local files' do
    let(:absolute_path_to_test_file) { "#{OpsHelper::VENDOR_BASE}/jasmine-simple-example/test.html" }
  end
end
