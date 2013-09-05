require 'spec_helper'

describe 'phantom-mocha.js (with failing spec)' do
  let(:script) { File.expand_path('../phantom-mocha.js', File.dirname(__FILE__)) }

  def assert_output(lines)
    lines.length.should == 13
    lines[0].should == "Calculator #divide divides correctly:"
    lines[1].should == "TypeError: 'undefined' is not a function (evaluating 'Calculator.divide(10, 5)')"
    lines[2].should == ""
    lines[3].should == "Calculator #subtract subtracts correctly:"
    lines[4].should == "TypeError: 'undefined' is not a function (evaluating 'Calculator.subtract(9, 5)')"
    lines[5].should == ""
    lines[6].should == "Calculator #power operates correctly:"
    lines[7].should == "TypeError: 'undefined' is not a function (evaluating 'Calculator.power(2, 5)')"
    lines[8].should == ""
    lines[9].should == "Tests passed: 2"
    lines[10].should == "Tests failed: 3"
    lines[11].should == "Total tests:  5"
    lines[12].should match /^Runtime \(ms\): \d+$/
  end

  it 'works against the mocha example' do
    lines = %x{phantomjs #{script} "http://localhost:#{OpenPhantomHelper::PORT}/mocha-example/test.html"}.lines.map(&:chomp)
    $?.exitstatus.should == 3
    assert_output(lines)
  end

  it_behaves_like 'from local files' do
    let(:absolute_path_to_test_file) { "#{OpenPhantomHelper::VENDOR_BASE}/mocha-example/test.html" }
    let(:expected_exit_status) { 3 }
  end
end
