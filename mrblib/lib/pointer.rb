class FFI::Pointer < CFunc::Pointer
  def self.new(*args)
    if args.size == 1
      new(args[0])
    else
      type, ptr = args
      CFunc::Pointer(type).refer(ptr.addr)
    end
  end
  
  def write_array_of type,a
    ca = CFunc::CArray(TYPES[type]).refer(self.addr)

    a.each_with_index do |q,i|
      ca[i].value = q
    end
    return self
  end
  
  def read_void
    nil
  end
  
  def read_array_of type,len
    ca = CFunc::CArray(TYPES[type]).refer(self.addr)
    (0...len).map do |i|
      type == :pointer ? FFI::Pointer.refer(ca[i].value.addr) : ca[i].value
    end 
  end
  
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
  
  def read_array_of_string len
    read_array_of :pointer,len do |y|
      yield CFunc::CArray(CFunc::SInt8).refer(y.addr).to_s
    end
  end
  
  def get_pointer offset
    FFI::Pointer.refer(self[offset].addr)
  end
  
  def read_string
    value.to_s
  end
  
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
  
  def read_type type
    return TYPES[type].get(self)
  end
  
  def write_type n,type
    TYPES[type].set(self, n)
    return self
  end
  
  FFI::TYPES.keys.each do |k|
    unless k == :string or k == :array
      define_method :"read_#{k}" do
        next read_type k
      end

      define_method :"write_#{k}" do |v|
        next write_type v,k
      end
      define_method :"write_array_of_#{k}" do |v|
        next write_array_of k,v
      end  
      define_method :"read_array_of_#{k}" do |v,&b|
        next read_array_of(k,v)
      end            
    end
  end
  
  def read_bool
    return read_int == 1
  end
  
  def read_array_of_bool len
    read_array_of_int len do |i|
      yield i == 1
    end
    return nil
  end
end
  
class FFI::MemoryPointer < FFI::Pointer
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
