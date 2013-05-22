

def assert_equal(expected, given)
  if expected != given
    raise "Expected #{expected}, got #{given}"
  end
end

alias :eq :assert_equal

def should(msg)
  print "Should #{msg}... #{' ' * (30 - msg.size)}"
  yield
  puts "OK"
end

