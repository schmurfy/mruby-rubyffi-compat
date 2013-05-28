module Cvalue2RubyValue
  # Converts a C value to Ruby from information of a (Argument || Return)
  def to_ruby ptr
    if type == :pointer
      return ptr
    elsif type == :enum
      r = ptr.send :"read_int"
      return r if r == -1
      return enum.enum?[r]
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
class Argument < Struct.new(:type,:callback,:value,:index,:enum)
  # Sets value from an argument passed to Function#invoke
  def set v
    self[:value] = v
  end
  
  include FFIType2CFuncType
  
  # Resolve and create the appropiate 
  # pointer from Argument properties for Function#invoke
  def make_pointer mul = 1
    if type == :callback
      if value.is_a?(CFunc::Closure)
        return value
      elsif cb=FFI::Library.callbacks[callback]
        return FFI::Closure.add callback,cb[1],cb[0]
      else
        return FFI::DefaultClosure.new
      end
    else
      tt = FFI::TYPES[type] ? type : :pointer
      
      q=FFI::MemoryPointer.new(tt,mul)
      return q#FFI::MemoryPointer.new(tt,mul)
    end
  end
  
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
class Return < Struct.new(:type,:enum)
  include FFIType2CFuncType
  
  def get_c_type
    if type == :enum
      CFunc::Int
    elsif type == :object
      CFunc::Pointer
    else
      FFI::TYPES[type]
    end
  end
  
  include Cvalue2RubyValue
  
  # returns a Ruby value of the passes ptr
  # resolved from Return properties
  def to_ruby ptr
    if FFI::C_NUMERICS.index(ptr.class)
      if type == :bool
        ptr.value == 1
      else
        n = ptr.value
  
        if type == :enum
          return enum.enum?[n]
        end
  
        return n
      end
    else
      ptr = FFI::Pointer.refer(ptr.addr)
      return super(ptr)
    end
  end
end
