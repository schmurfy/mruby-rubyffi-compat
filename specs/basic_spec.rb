module FFITests
  module CLib
    extend FFI::Library
    
    ffi_lib :c
    
    attach_function :sleep, [:uint32], :uint32
    attach_function :abs, [:int],:int
  end
  
  module TestLib
    extend FFI::Library
    
    ffi_lib [
      './specs/libtest/libtest.so',
      '/Users/schmurfy/Dev/personal/mrbgems/mruby-rubyffi-compat/specs/libtest/libtest.dylib'
    ]
    
    attach_function :return_uint, [:uint32], :uint32
    attach_function :return_double, [:double], :double
    attach_function :return_uint_by_address, [:pointer], :void
    
  end
end

header "Basic tests"
# Fix for issue #3 made use of .addr required
should 'return integer by address' do
  n = FFI::MemoryPointer.new(:uint32)
  FFITests::TestLib.return_uint_by_address(n.addr)
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

# only test on mruby
if ::Object.const_defined?(:CFunc)
  # Issue #3
  # Behaviour was segfault
  should 'set and retieve values properly' do
    int = CFunc::UInt32.new()
    ptr = FFI::Pointer.refer(int.addr)
    ptr.write_int(2)
    assert_equal(2,ptr.read_int)
  end
end

# Issue #3
# Ensure values are not addresses!
should "return 2" do
  eq 2,FFITests::CLib.abs(2)
end

should 'sleep 1s' do
  t = Time.now
  FFITests::CLib.sleep(1)
  assert_equal(1, (Time.now - t).to_i)
end
