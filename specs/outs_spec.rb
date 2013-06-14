module FFITests::TestLib
  class FooBar < FFI::Struct
    layout :id,:int
  end
  
  attach_function :foo_bar_new,[],FooBar.by_ref
  attach_function :foo_set_a_bar,[:pointer],:void
  attach_function :foo_set_a_string,[:pointer],:void  
  attach_function :foo_set_array_of_bar,[:pointer],:void
  attach_function :foo_set_array_of_string,[:pointer],:void  
end

header "Test of out parameters"

should "point to Struct" do
  foo = FFI::MemoryPointer.new(:pointer)
  FFITests::TestLib.foo_set_a_bar(foo)
  foo = foo.get_pointer(0)
  assert_equal 1,FFITests::TestLib::FooBar.new(foo)[:id]
end

should "point to array of Struct" do
  ptr = FFI::MemoryPointer.new(:pointer)

  FFITests::TestLib.foo_set_array_of_bar(ptr)

  i = 2
  ptr.get_pointer(0).read_array_of_pointer(2).each do |q|
    assert_equal i,FFITests::TestLib::FooBar.new(q)[:id]
    i+=1
  end
end

should "point to string" do
  out = FFI::MemoryPointer.new(:pointer)
  FFITests::TestLib.foo_set_a_string(out)

  ptr = out.get_pointer(0)
  assert_equal "hello",ptr.read_string
end

should "point to array of string" do
  out = FFI::MemoryPointer.new(:pointer)
  FFITests::TestLib.foo_set_array_of_string(out)

  ptr = out.get_pointer(0)

  assert_equal(["tree","fall"],(ptr.read_array_of_pointer(2).map do |q|
    q.read_string
  end))

  assert_equal(["tree","fall"], ptr.get_array_of_string(0,2))
end 
