module FFITests
  module TestLib2
    extend FFI::Library
  end

   module TestLib3
    extend FFI::Library
  end   
end

header "Sanity"

f = f1 = dlibs = nil

lib = FFITests::TestLib2
lib1 = FFITests::TestLib3

dlibs1 = lib1.ffi_lib("c")

should "Load Library" do
  dlibs = lib.ffi_lib("c")
end

should "Return array of DynamicLibrary" do
  assert_true dlibs.is_a?(Array)
  assert_false dlibs.empty?
end

should "Attach Function" do
  f = lib.attach_function :abs,[:int],:int
  assert_true lib.respond_to?(:abs)
end

should "Return FFI::Function" do
  assert_true f.is_a?(FFI::Function)
end

should "Return sane result of calling function" do
  assert_equal 2,lib.abs(-2)
  assert_equal 2,f.call(-2)  
end

should "Provide manual means of binding" do
  addr = nil
  
  lib = dlibs1.find do |l|
    addr = l.find_symbol("abs")
  end
  
  assert_true !!lib
  assert_true !!addr
  
  f1 = FFI::Function.new(:int,[:int],addr)
  f1.attach lib1,"abs"
 
  assert_true lib1.respond_to?(:abs)
  assert_equal 2,lib1.abs(-2)
  assert_equal 2,f1.call(-2)  
end

