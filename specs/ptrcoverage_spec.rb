header('FFI::Pointer Read/Write tests')
      
should "write int8 and read it back" do
  ptr = FFI::MemoryPointer.new(:int8)
  ptr.write_int8 33
  assert_equal 33,ptr.read_int8
end
      
should "write uint8 and read it back" do
  ptr = FFI::MemoryPointer.new(:uint8)
  ptr.write_uint8 33
  assert_equal 33,ptr.read_uint8
end
      
should "write int16 and read it back" do
  ptr = FFI::MemoryPointer.new(:int16)
  ptr.write_int16 33
  assert_equal 33,ptr.read_int16
end
      
should "write uint16 and read it back" do
  ptr = FFI::MemoryPointer.new(:uint16)
  ptr.write_uint16 33
  assert_equal 33,ptr.read_uint16
end
      
should "write int32 and read it back" do
  ptr = FFI::MemoryPointer.new(:int32)
  ptr.write_int32 33
  assert_equal 33,ptr.read_int32
end
      
should "write uint32 and read it back" do
  ptr = FFI::MemoryPointer.new(:uint32)
  ptr.write_uint32 33
  assert_equal 33,ptr.read_uint32
end
      
should "write int64 and read it back" do
  ptr = FFI::MemoryPointer.new(:int64)
  ptr.write_int64 33
  assert_equal 33,ptr.read_int64
end
      
should "write uint64 and read it back" do
  ptr = FFI::MemoryPointer.new(:uint64)
  ptr.write_uint64 33
  assert_equal 33,ptr.read_uint64
end
      
should "write int and read it back" do
  ptr = FFI::MemoryPointer.new(:int)
  ptr.write_int 33
  assert_equal 33,ptr.read_int
end
      
should "write uint and read it back" do
  ptr = FFI::MemoryPointer.new(:uint)
  ptr.write_uint 33
  assert_equal 33,ptr.read_uint
end
      
should "write double and read it back" do
  ptr = FFI::MemoryPointer.new(:double)
  ptr.write_double 33.3
  assert_equal 33.3, ptr.read_double
end
      
should "write pointer and read it back" do
  ptr2 = FFI::MemoryPointer.new(:pointer)
  ptr2.write_string "hello"
  ptr = FFI::MemoryPointer.new(:pointer)
  ptr.write_pointer ptr2
  assert_equal "hello", ptr.read_pointer.read_string
end

header('FFI::Pointer Put/Get tests')

      
should "put int8 and read it back" do
  ptr = FFI::MemoryPointer.new(:pointer)
  ptr.put_int8 0,3
  assert_equal 3,ptr.get_int8(0)
end

      
should "put uint8 and read it back" do
  ptr = FFI::MemoryPointer.new(:pointer)
  ptr.put_uint8 0,3
  assert_equal 3,ptr.get_uint8(0)
end

      
should "put int16 and read it back" do
  ptr = FFI::MemoryPointer.new(:pointer)
  ptr.put_int16 0,3
  assert_equal 3,ptr.get_int16(0)
end

      
should "put uint16 and read it back" do
  ptr = FFI::MemoryPointer.new(:pointer)
  ptr.put_uint16 0,3
  assert_equal 3,ptr.get_uint16(0)
end

      
should "put int32 and read it back" do
  ptr = FFI::MemoryPointer.new(:pointer)
  ptr.put_int32 0,3
  assert_equal 3,ptr.get_int32(0)
end

      
should "put uint32 and read it back" do
  ptr = FFI::MemoryPointer.new(:pointer)
  ptr.put_uint32 0,3
  assert_equal 3,ptr.get_uint32(0)
end

      
should "put int64 and read it back" do
  ptr = FFI::MemoryPointer.new(:pointer)
  ptr.put_int64 0,3
  assert_equal 3,ptr.get_int64(0)
end

      
should "put uint64 and read it back" do
  ptr = FFI::MemoryPointer.new(:pointer)
  ptr.put_uint64 0,3
  assert_equal 3,ptr.get_uint64(0)
end





      
should "put int and read it back" do
  ptr = FFI::MemoryPointer.new(:pointer)
  ptr.put_int 0,3
  assert_equal 3,ptr.get_int(0)
end

      
should "put uint and read it back" do
  ptr = FFI::MemoryPointer.new(:pointer)
  ptr.put_uint 0,3
  assert_equal 3,ptr.get_uint(0)
end

      
should "put double and read it back" do
  ptr = FFI::MemoryPointer.new(:pointer)
  ptr.put_double 0,3.3
  assert_equal 3.3,ptr.get_double(0)
end

      
should "put pointer and read it back" do
  ptr = FFI::MemoryPointer.new(:pointer)
  ps = FFI::MemoryPointer.new(:pointer)
  ps.write_string "hello"
  ptr.put_pointer 0,ps
  assert_equal "hello",ptr.get_pointer(0).read_string
end

header('FFI::Pointer Array Read/Write tests')
        
should "write array of int8 and read it back" do
  aptr = FFI::MemoryPointer.new(:int8,4)
  aptr.write_array_of_int8 [1,2,3,4]
  assert_equal [1,2,3,4],aptr.read_array_of_int8(4)
end
        
should "write array of uint8 and read it back" do
  aptr = FFI::MemoryPointer.new(:uint8,4)
  aptr.write_array_of_uint8 [1,2,3,4]
  assert_equal [1,2,3,4],aptr.read_array_of_uint8(4)
end
        
should "write array of int16 and read it back" do
  aptr = FFI::MemoryPointer.new(:int16,4)
  aptr.write_array_of_int16 [1,2,3,4]
  assert_equal [1,2,3,4],aptr.read_array_of_int16(4)
end
        
should "write array of uint16 and read it back" do
  aptr = FFI::MemoryPointer.new(:uint16,4)
  aptr.write_array_of_uint16 [1,2,3,4]
  assert_equal [1,2,3,4],aptr.read_array_of_uint16(4)
end
        
should "write array of int32 and read it back" do
  aptr = FFI::MemoryPointer.new(:int32,4)
  aptr.write_array_of_int32 [1,2,3,4]
  assert_equal [1,2,3,4],aptr.read_array_of_int32(4)
end
        
should "write array of uint32 and read it back" do
  aptr = FFI::MemoryPointer.new(:uint32,4)
  aptr.write_array_of_uint32 [1,2,3,4]
  assert_equal [1,2,3,4],aptr.read_array_of_uint32(4)
end
        
should "write array of int64 and read it back" do
  aptr = FFI::MemoryPointer.new(:int64,4)
  aptr.write_array_of_int64 [1,2,3,4]
  assert_equal [1,2,3,4],aptr.read_array_of_int64(4)
end
        
should "write array of uint64 and read it back" do
  aptr = FFI::MemoryPointer.new(:uint64,4)
  aptr.write_array_of_uint64 [1,2,3,4]
  assert_equal [1,2,3,4],aptr.read_array_of_uint64(4)
end
        
should "write array of int and read it back" do
  aptr = FFI::MemoryPointer.new(:int,4)
  aptr.write_array_of_int [1,2,3,4]
  assert_equal [1,2,3,4],aptr.read_array_of_int(4)
end
        
should "write array of uint and read it back" do
  aptr = FFI::MemoryPointer.new(:uint,4)
  aptr.write_array_of_uint [1,2,3,4]
  assert_equal [1,2,3,4],aptr.read_array_of_uint(4)
end
        
should "write array of double and read it back" do
  aptr = FFI::MemoryPointer.new(:double,2)
  aptr.write_array_of_double [22.2,33.3]
  assert_equal [22.2,33.3],aptr.read_array_of_double(2)
end
        
should "write array_of_pointer and be able to read it back" do
  aptr = FFI::MemoryPointer.new(:pointer,4)
  pa = []
  [0,1,2,3].each do |i|
    pa << this=FFI::MemoryPointer.new(:pointer)
    this.write_string "test_"+i.to_s
  end
  aptr.write_array_of_pointer pa
  aptr.read_array_of_pointer(pa.length).each_with_index do |q,i|
    assert_equal "test_"+i.to_s, q.read_string
  end
end

header('FFI::Pointer Array Put/Get tests')

        
should "put array_of_int8 and read it back" do
  ptr = FFI::MemoryPointer.new(:int8,4)
  ptr.put_array_of_int8 0,[1,2,3,4]
  assert_equal [1,2,3,4], ptr.get_array_of_int8(0,4)
end

        
should "put array_of_uint8 and read it back" do
  ptr = FFI::MemoryPointer.new(:uint8,4)
  ptr.put_array_of_uint8 0,[1,2,3,4]
  assert_equal [1,2,3,4], ptr.get_array_of_uint8(0,4)
end

        
should "put array_of_int16 and read it back" do
  ptr = FFI::MemoryPointer.new(:int16,4)
  ptr.put_array_of_int16 0,[1,2,3,4]
  assert_equal [1,2,3,4], ptr.get_array_of_int16(0,4)
end

        
should "put array_of_uint16 and read it back" do
  ptr = FFI::MemoryPointer.new(:uint16,4)
  ptr.put_array_of_uint16 0,[1,2,3,4]
  assert_equal [1,2,3,4], ptr.get_array_of_uint16(0,4)
end

        
should "put array_of_int32 and read it back" do
  ptr = FFI::MemoryPointer.new(:int32,4)
  ptr.put_array_of_int32 0,[1,2,3,4]
  assert_equal [1,2,3,4], ptr.get_array_of_int32(0,4)
end

        
should "put array_of_uint32 and read it back" do
  ptr = FFI::MemoryPointer.new(:uint32,4)
  ptr.put_array_of_uint32 0,[1,2,3,4]
  assert_equal [1,2,3,4], ptr.get_array_of_uint32(0,4)
end

        
should "put array_of_int64 and read it back" do
  ptr = FFI::MemoryPointer.new(:int64,4)
  ptr.put_array_of_int64 0,[1,2,3,4]
  assert_equal [1,2,3,4], ptr.get_array_of_int64(0,4)
end

        
should "put array_of_uint64 and read it back" do
  ptr = FFI::MemoryPointer.new(:uint64,4)
  ptr.put_array_of_uint64 0,[1,2,3,4]
  assert_equal [1,2,3,4], ptr.get_array_of_uint64(0,4)
end





        
should "put array_of_int and read it back" do
  ptr = FFI::MemoryPointer.new(:int,4)
  ptr.put_array_of_int 0,[1,2,3,4]
  assert_equal [1,2,3,4], ptr.get_array_of_int(0,4)
end

        
should "put array_of_uint and read it back" do
  ptr = FFI::MemoryPointer.new(:uint,4)
  ptr.put_array_of_uint 0,[1,2,3,4]
  assert_equal [1,2,3,4], ptr.get_array_of_uint(0,4)
end

        
should "put array_of_double and read it back" do
  ptr = FFI::MemoryPointer.new(:double,4)
  ptr.put_array_of_double 0,[22.2,33.3]
  assert_equal [22.2,33.3], ptr.get_array_of_double(0,2)
end

        
should "put array_of_pointer and be able to read it back" do
  aptr = FFI::MemoryPointer.new(:pointer,32)
  pa = []
  [0,1,2,3].each do |i|
    pa << this=FFI::MemoryPointer.new(:pointer)
    this.write_string "test_"+i.to_s
  end
  
  aptr.put_array_of_pointer 8,pa
  aptr.get_array_of_pointer(8,pa.length).each_with_index do |q,i|
    assert_equal "test_"+i.to_s, q.read_string
  end
  
  pa = []
  [0,1,2,3].each do |i|
    pa << this=FFI::MemoryPointer.new(:pointer)
    this.write_string "test2_"+i.to_s
  end	
  
  aptr.put_array_of_pointer 0,pa
  aptr.get_array_of_pointer(0,pa.length).each_with_index do |q,i|
    assert_equal "test2_"+i.to_s, q.read_string
  end	
  
  aptr.put_array_of_pointer 8,pa
  aptr.get_array_of_pointer(8,pa.length).each_with_index do |q,i|
    assert_false "test_"+i.to_s == q.read_string
  end	  
end
  
should "get array_of_string" do
  aptr = FFI::MemoryPointer.new(:pointer,2)
  p1 = FFI::MemoryPointer.new(:pointer)
  p2 = FFI::MemoryPointer.new(:pointer)
  p1.write_string "tree"
  p2.write_string "fall"
  aptr.write_array_of_pointer [p1,p2]
  assert_equal ["tree","fall"],aptr.get_array_of_string(0,2)
end
