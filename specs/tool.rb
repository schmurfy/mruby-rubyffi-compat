

def assert_equal(expected, given)
  if expected != given
    raise "Expected #{expected}, got #{given.inspect}"
  end
end

def assert_true(g)
  eq(true,g)
end

def assert_false(g)
  eq(false,g)
end

def assert q
  assert_equal true,!!q
end

alias :eq :assert_equal


def header(str)
  puts "\n#{str}:"
end

def should(msg)
  spaces = 50 - msg.size
  if spaces < 0
    raise "raise spaces count in tool.rb"
  end
  
  print "  Should #{msg}... #{' ' * spaces}"
  yield
  puts "OK"
end


