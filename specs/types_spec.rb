module FFITests
  # Works with MRI and mruby
  module TestLib
    typedef :int,:my_int
      
    class SomeStruct < FFI::Struct
      layout :id,:my_int,
	    :name,:string
    end   
    
    attach_function :some_struct_new,      [:string],    SomeStruct.by_ref
    attach_function :some_struct_get_id,   [SomeStruct], :my_int
    attach_function :some_struct_get_name, [SomeStruct], :string
    
    class SomeUnion < FFI::Union
      layout :int_v,   :int32,
            :struct_v, SomeStruct,
            :buffer_v, [:uint8, 4]
    end
    
    attach_function :some_union_new,         [],         SomeUnion.by_ref
    attach_function :some_union_fill_int,    [SomeUnion], :void
    attach_function :some_union_fill_struct, [SomeUnion], :void
    attach_function :some_union_fill_buffer, [SomeUnion], :void
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

u = nil

should "Return `SomeUnion` instance" do
  u = FFITests::TestLib.some_union_new()
  assert_equal true,u.is_a?(FFITests::TestLib::SomeUnion)
end

should "Read int member" do
  FFITests::TestLib.some_union_fill_int(u)
  assert_equal 63, u[:int_v]
end

should "Read struct member" do
  FFITests::TestLib.some_union_fill_struct(u)
  v = u[:struct_v]
  assert_true v.is_a?(FFITests::TestLib::SomeStruct) and v[:name] == "union_member"
end

should "Read buffer member" do
  FFITests::TestLib.some_union_fill_buffer(u)
  assert_equal u[:buffer_v].to_s, "ABC"
end
