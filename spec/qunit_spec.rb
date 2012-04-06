require 'spec_helper'

describe 'phantom-qunit.js' do
  let(:script) { File.expand_path('../phantom-qunit.js', File.dirname(__FILE__)) }

  def assert_output(lines)
    lines.length.should == 4
    # Correct for current specs in Underscore according to submodule SHA
    lines[0].should == 'Tests passed: 477'
    lines[1].should == 'Tests failed: 0'
    lines[2].should == 'Total tests:  477'
    lines[3].should match /^Runtime \(ms\): \d+$/
  end

  it 'works against the Underscore.js test suite' do
    lines = %x{phantomjs #{script} "http://localhost:#{OpenPhantomHelper::PORT}/underscore/test/test.html"}.lines.map(&:chomp)
    $?.exitstatus.should == 0
    assert_output(lines)
  end

  it_behaves_like 'correct failures'

  it_behaves_like 'from local files' do
    let(:absolute_path_to_test_file) { "#{OpenPhantomHelper::VENDOR_BASE}/underscore/test/test.html" }
  end
end
