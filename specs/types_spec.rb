module FFITests
  # Works with MRI and mruby
  module TestLib
    typedef :int,:my_int
      
    class SomeStruct < FFI::Struct
      layout :id,:my_int,
	    :name,:string
    end   
    
    attach_function :some_struct_new,[:string],SomeStruct.by_ref
    attach_function :some_struct_get_id,[SomeStruct],:my_int
    
    attach_function :some_struct_get_name,[SomeStruct],:string  
  end
end 

header "Types tests"

struct = nil

should "Return `SomeStruct` instance" do
  struct = FFITests::TestLib.some_struct_new("Bob")
  assert_equal true,struct.is_a?(FFITests::TestLib::SomeStruct)
end

should "Allow typedef in struct field" do
  assert_true struct[:id].is_a?(Integer)
end

id = nil

should "Take SomeStruct as parameter" do
  id = FFITests::TestLib::some_struct_get_id(struct)
  assert_equal true,!!id
end

should "Resolve typedef :my_int to :int" do
  assert_true id.is_a?(Integer)
end

should "Values should be sane" do
  assert_equal id,struct[:id]
  s2 = FFITests::TestLib.some_struct_new("Fred")
  assert_false s2[:id] == id
end

should "Allow pointer as parameter" do
  id = FFITests::TestLib::some_struct_get_id(struct.addr)
  assert_equal true,!!id
end
