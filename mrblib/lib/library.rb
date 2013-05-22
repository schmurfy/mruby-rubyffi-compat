module FFI::Library
  def ffi_lib(libname)
    @ffi_lib = libname
  end
  
  @@callbacks = {}
  def callback(name, arguments_type, result_type)
    @@callbacks[name] = [ arguments_type.map{|t| FFI::TYPES[t]}, FFI::TYPES[result_type] ]
  end
  
  def self.callbacks
    @@callbacks
  end
  

  
  def typedef(type_name, alias_name)
    FFI::TYPES[alias_name] = FFI.find_type(type_name)
  end  
  
  @@enums = {}
  def enum(enum_name, arr)
    idx = 0
    values = {}
    
    pos = 0
    loop do
      name = arr[pos]
      value = arr[pos+1]
      
      if value.is_a?(Integer)
        idx = value
        pos += 2
      else
        pos += 1
      end
      
      values[name] = idx
      idx += 1
      
      break if pos >= arr.size
    end
    
    @@enums[enum_name] = values
    typedef(:int, enum_name)
    
    self
  end

  def self.enums
    @@enums
  end  
  
  def attach_function(function_name, arguments_type, result_type)
    f= add_function(@ffi_lib, function_name, arguments_type, result_type)

    singleton_class.define_method(function_name) do |*args, &b|  
      f.invoke(*args, &b)
    end
    
    self
  end
  
end
