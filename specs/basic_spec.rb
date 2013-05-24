

module FFITests
  module CLib
    extend FFI::Library
    
    ffi_lib :c
    
    attach_function :sleep, [:uint32], :uint32
  end
  
  module TestLib
    extend FFI::Library
    
    ffi_lib [
      '/home/ubuntu/mruby-rubyffi-compat/specs/libtest/libtest.so',
      '/Users/schmurfy/Dev/personal/mrbgems/mruby-rubyffi-compat/specs/libtest/libtest.dylib'
    ]
    
    attach_function :return_uint, [:uint32], :uint32
    attach_function :return_double, [:double], :double
    attach_function :return_uint_by_address, [:pointer], :void
    
    
    class S1Struct < FFI::Struct
      layout(
          :n1,  :uint32,
          :n2,  :uint32,
          :s1,  :uint16,
          :d1,  :double,
        )
    end
    
    attach_function :fill_struct, [:pointer], :void
  end
end

header "Basic tests"


should 'return integer by address' do
  n = FFI::MemoryPointer.new(:uint32)
  FFITests::TestLib.return_uint_by_address(n)
  assert_equal(42, n.read_uint32())
end

should 'return integer by value' do
  ret = FFITests::TestLib.return_uint(4)
  assert_equal(4, ret)
end

should 'return double by value' do
  ret = FFITests::TestLib.return_double(4.32)
  assert_equal(4.32, ret)
end

should 'fill structure' do
  s = FFITests::TestLib::S1Struct.new
  FFITests::TestLib.fill_struct(s.addr)
  
  assert_equal(56, s[:n1])
  assert_equal(982, s[:n2])
  assert_equal(12, s[:s1])
  assert_equal(6.78, s[:d1])
end


should 'sleep 1s' do
  t = Time.now
  FFITests::CLib.sleep(1)
  assert_equal(1, (Time.now - t).to_i)
end

