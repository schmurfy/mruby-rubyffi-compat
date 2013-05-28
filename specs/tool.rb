

def assert_equal(expected, given)
  if expected != given
    raise "Expected #{expected}, got #{given}"
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
  print "  Should #{msg}... #{' ' * (35 - msg.size)}"
  yield
  puts "OK"
end


