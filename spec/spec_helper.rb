require 'rubygems'

def assert_has_phantomjs
  raise 'Could not locate phantomjs binary!' unless system('which phantomjs')
end
