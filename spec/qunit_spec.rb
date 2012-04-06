require 'spec_helper'

describe 'phantom-qunit.js' do
  script = File.expand_path('../phantom-qunit.js', File.dirname(__FILE__))

  it 'works against the Underscore.js test suite' do
    lines = %x{phantomjs #{script} "http://localhost:#{OpsHelper::PORT}/underscore/test/test.html"}.lines.map(&:chomp)
    $?.exitstatus.should == 0
    lines.length.should == 4
    # Correct for current specs in Underscore according to submodule SHA
    lines[0].should == 'Tests passed: 477'
    lines[1].should == 'Tests failed: 0'
    lines[2].should == 'Total: 477'
    lines[3].should match /^Runtime \(ms\): \d+$/
  end

  it_behaves_like 'correct failures' do
    let(:script) { script }
  end
end
