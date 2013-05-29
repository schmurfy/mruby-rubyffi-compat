module FFITests
  module TestLib
    class S1Struct < FFI::Struct
      layout(
          :n1,  :uint32,
          :n2,  :uint32,
          :s1,  :uint16,
          :d1,  :double,
        )
    end
    
    class BufferStruct < FFI::Struct 
      layout(
          :id,    :uint8, 
          :name,  [:uint8, 5]
        )
    end 
    
    attach_function :fill_struct, [:pointer], :void
    attach_function :create_buffer, [], :pointer
    attach_function :inspect_buffer, [:pointer], :void
  end
end


header "Structures tests"


should 'fill structure' do
  s = FFITests::TestLib::S1Struct.new
  FFITests::TestLib.fill_struct(s.addr)
  
  eq(56,    s[:n1])
  eq(982,   s[:n2])
  eq(12,    s[:s1])
  eq(6.78,  s[:d1])
end


