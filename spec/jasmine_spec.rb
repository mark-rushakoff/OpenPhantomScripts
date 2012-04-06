require 'spec_helper'

describe 'phantom-jasmine.js' do
  script = File.expand_path('../phantom-jasmine.js', File.dirname(__FILE__))

  it 'works against the sample Jasmine test suite' do
    lines = %x{phantomjs #{script} "http://localhost:#{OpsHelper::PORT}/jasmine-simple-example/test.html"}.lines.map(&:chomp)
    $?.exitstatus.should == 0
    lines.length.should == 5
    lines[0].should == 'Tests passed:  5'
    lines[1].should == 'Tests skipped: 0'
    lines[2].should == 'Tests failed:  0'
    lines[3].should == 'Total tests:   5'
    lines[4].should match /^Runtime \(ms\):  \d+$/
  end

  it_behaves_like 'correct failures' do
    let(:script) { script }
  end
end
