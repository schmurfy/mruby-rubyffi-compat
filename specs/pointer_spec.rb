
header 'Pointer tests'

should 'support array read/write' do
  p = FFI::MemoryPointer.new(:int, 2)
  p.write_array_of_int32([2, 1])
  
  eq([2, 1], p.read_array_of_int32(2))
end


should 'support array get/put' do
  p = FFI::MemoryPointer.new(:uint16, 4)
  p.put_array_of_uint16(4, [ 2, 1 ])
  p.put_array_of_uint16(0, [ 12, 56 ])
  
  eq([56, 2], p.get_array_of_uint16(2, 2))
end

