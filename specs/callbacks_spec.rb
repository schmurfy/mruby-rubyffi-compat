module FFITests
  module TestLib
    class SomeObject < FFI::Struct
      layout :next,  :pointer,
             :name,  :string,
             :value, :double
    end
    
    callback :object_callback, [:pointer, :double], :void
    
    attach_function :create_object, [:double], :pointer
    attach_function :free_object, [:pointer], :void
    attach_function :set_object_callback, [:pointer, :object_callback], :void
  end
end

header "Callback tests"

should 'call the callback' do
  val = nil
  
  cb = proc do |ptr, size|
    obj = FFITests::TestLib::SomeObject.new(ptr)
    val = obj[:value]
  end
  
  obj_ptr = FFI::MemoryPointer.new(:pointer)
  obj_ptr = FFITests::TestLib.create_object(6.54)
  
  obj = FFITests::TestLib::SomeObject.new(obj_ptr)
  eq(6.54, obj[:value])
  FFITests::TestLib.set_object_callback(obj.pointer, cb)
  eq(val, 6.54)
end



