module Cvalue2RubyValue
  # Converts a C value to Ruby from information of a (Argument || Return)
  def to_ruby ptr
    if type == :pointer
      return ptr
    elsif e=FFI::Library.enums[type]
      q = ptr.value
	    return e.find do |k,v|
	      v == q
	    end[0] || q
    else 
      tt = type
      return ptr.send(:"read_#{tt}")  
    end
  end
  
  # true if type is a C numeric type
  def is_numeric?
    FFI::C_NUMERICS.index(FFI::TYPES[type])
  end
    
end 

# Represents Argument information
# and defines ways to create and convert
# Arguments to/from c
class Argument < Struct.new(:type,:value,:index)
  # Sets value from an argument passed to Function#invoke
  def set v
    self[:value] = v
  end
  
  include FFIType2CFuncType
    
  include Cvalue2RubyValue
  
  # Sets the appropiate value for an Argument for Function#invoke
  def for_invoke      
      enum_type = FFI::Library.enums[type]
      
      if enum_type
        CFunc::Int.new(enum_type[value])
      
      elsif type == :string
        value
        
      elsif (cfunc_type = FFI::TYPES[type])
        cfunc_type.new(value)
      
      elsif (callback_type = FFI::Library.callbacks[type])
        FFI::Closure.new(callback_type[1], callback_type[0], &value)
        
      else
        raise "Unsupported type: #{type}"
      end
  end
end


# Represents information of a return_value of Function#invoke
class Return < Struct.new(:type)
  include FFIType2CFuncType
  
  def get_c_type
      FFI::TYPES[type]
  end
  
  include Cvalue2RubyValue
  
  # returns a Ruby value of the passes ptr
  # resolved from Return properties
  def to_ruby ptr
    if FFI::C_NUMERICS.index(ptr.class)
      if type == :bool
        ptr.value == 1
      else
        q = ptr.value
        
        if e=FFI::Library.enums[type]
	        return e.find do |k,v|
	          v == q
	        end[0] || q
	      end
      	
        return q
      end
    else
      ptr = FFI::Pointer.refer(ptr.addr)
      return super(ptr)
    end
  end
end
