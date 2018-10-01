class FFI::Pointer < CFunc::Pointer
  # @overload new(ptr)
  def self.new(*args)
    if args.size == 1
      new(args[0])
    else
      type, ptr = args
      CFunc::Pointer(type).refer(ptr.addr)
    end
  end

  # NULL Pointer
  self::NULL = self.new
  
  # Compatability method
  # Useful for comparing two pointers
  #
  # @return Integer, pointer address
  def address
      lh = Class.new(FFI::Union)
      lh.layout(:high,:uint32,:low,:uint32)
    
      val = lh.new(addr)
      low  = val[:low]
      high = val[:high]
      
      return((high << 32) | low)
  end
        
  # writes an array of +type+ at +offset+ of arr
  # @param type [Symbol] to resolve array member types
  # @param arr [Array] of suitable members to cast to +type+
  # @return self
  def put_array_of(offset, type, arr)
    ca = CFunc::CArray(TYPES[type]).refer(self.offset(offset).addr)

    arr.each_with_index do |q, i|
      ca[i].value = q
    end
    return self
  end
  
  # @return nil
  def read_void
    nil
  end
  
  # @return array of +type+ at +offset+ of +len+
  def get_array_of(offset, type, len)
    ca = CFunc::CArray(TYPES[type]).refer(self.offset(offset).addr)
    (0...len).map do |i|
      type == :pointer ? FFI::Pointer.refer(ca[i].value.addr) : ca[i].value
    end 
  end
  
  # writes an array of strings
  #
  # @param sa [Array<String>] to write
  # @return self
  def write_array_of_string sa
    ca = CFunc::CArray(CFunc::Pointer).refer(self.addr)
    subt = 0
    
    sa.each_with_index do |q,i|
      ia = CFunc::SInt8[q.length]
      c = 0
      
      q.each_byte do |b|
        ia[c].value = b
        c += 1
      end
      
      ia[c].value = 0
      ca[i].value = ia
    end
    return self
  end
  
  # Reads an Array of strings of +len+
  #
  # @param len [Integer] specifies length
  # @return [Array<String>] of +len+
  def read_array_of_string len
    read_array_of :pointer,len do |y|
      yield CFunc::CArray(CFunc::SInt8).refer(y.addr).to_s
    end
  end
  
  # @return [FFI::Pointer] at +offset_
  def get_pointer offset
    FFI::Pointer.refer(self[offset].addr)
  end
  
  # @return [String]
  def read_string
    return nil if value.is_null?
    value.to_s
  end
  
  # writes a String of +str+
  #
  # @param str [String] to write
  # @return self
  def write_string(str)
    CFunc::call(CFunc::Pointer, "strcpy", self, str)
    # ca = CFunc::CArray(CFunc::SInt8).refer(self.addr)
    # c = 0
    
    # s.each_byte do |b|
    #   ca[c].value = b
    #   c += 1
    # end
    
    # ca[c].value = 0
    return self
  end
  
  # reads a type of resolved +type+
  # 
  # @param type [Symbol] to resolve
  # @return the result
  def read_type type
    return TYPES[type].get(self.addr)
  end
  
  # writes type of +type+ to +n+
  #
  # @param n the value to write
  # @param type [Symbol] the type to resolve
  # @return self
  def write_type n,type
    TYPES[type].set(self.addr, n)
    return self
  end
  
  # Read an array of +type+ of +len+ from offset 0
  # @param len [Integer]
  # @param type [Symbol] to resolve type
  # @return [Array] with the members resolved from +type+
  def read_array_of type,len,&b
    get_array_of(0, type,len,&b)    
  end
  
  # Write an array of +type+ of +ary+ at offset 0
  # @param ary [Array] of compatible members for +type+
  # @param type [Symbol] to resolve type
  # @return self
  def write_array_of type,ary,&b
    put_array_of(0, type,ary,&b)    
  end  
  
  FFI::TYPES.keys.each do |k|
    unless k == :string or k == :array
      define_method :"read_#{k}" do
        next read_type k
      end

      define_method :"write_#{k}" do |v|
        next write_type v,k
      end
      
      define_method :"put_array_of_#{k}" do |offset, v|
        put_array_of(offset, k, v)
      end
      
      define_method :"write_array_of_#{k}" do |v|
        write_array_of k,v
      end
      
      define_method :"get_array_of_#{k}" do |offset, v|
        get_array_of(offset, k,v)
      end            
      
      define_method :"read_array_of_#{k}" do |v,&b|
        read_array_of(k,v,&b)
      end
    end
  end
  
  # reads a boolean
  # @return [Boolean]
  def read_bool
    return read_int == 1
  end
  
  # Reads an array of Boolean
  #
  # @param len [Integer] length to read
  # @return [Array<Boolean>]
  def read_array_of_bool len
    read_array_of_int len do |i|
      yield i == 1
    end
    return nil
  end
end
  
class FFI::MemoryPointer < FFI::Pointer
  # @overload new(type,size)
  # @overload new(type,size,length)
  def self.new *o
    count = 1
    clear = false
    
    if o.length == 1
      size = o[0]
      if size.is_a?(Numeric)
        return malloc(size)
      end
    elsif o.length == 2
      size, count = o
    elsif o.length == 3
      size,count,clear = o
    else
      raise "arguments error > 4 for 1..3"
    end
    
    s = TYPES[size].size
    ins = malloc(s*count)

    return ins
  end  
end
