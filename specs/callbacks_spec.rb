module FFITests
  module TestLib
    class SomeObject < FFI::Struct
      layout :next,  :pointer,
             :name,  :string,
             :value, :double
    end
    
    class SomeStruct < FFI::Struct
      layout :id,:my_int,
	    :name,:string
    end  
    
    callback :types_callback, [SomeStruct.by_ref, :double], :bool
    
    callback :object_callback, [:pointer, :double], :void    
    attach_function :create_object, [:double], :pointer
    attach_function :free_object, [:pointer], :void
    attach_function :set_object_callback, [:pointer, :object_callback], :void
    attach_function :test_types_callback, [:types_callback], :void
  end
end

header "Callback tests"

should 'call the callback' do
  val = nil
  
  cb = proc do |ptr, size|
    obj = FFITests::TestLib::SomeObject.new(ptr)
    val = obj[:value]
    assert_equal 6.54,size
  end
  
  obj_ptr = FFI::MemoryPointer.new(:pointer)
  obj_ptr = FFITests::TestLib.create_object(6.54)
  
  obj = FFITests::TestLib::SomeObject.new(obj_ptr)
  eq(6.54, obj[:value])
  FFITests::TestLib.set_object_callback(obj.pointer, cb)
  eq(val, 6.54)
end

state = nil

should "Handle types in callback" do
  cb = proc do |some_obj,dbl|
    p some_obj
    assert_true(some_obj.is_a?(FFITests::TestLib::SomeStruct))
    assert_equal(3.3,dbl)
    state = true
  end

  FFITests::TestLib::test_types_callback(cb)

  assert_true(state)
end



