module Cvalue2RubyValue
  # Converts a C value to Ruby from information of a (Argument || Return)
  #
  # @param ptr [CFunc::Pointer] the pointer to perform conversions on.
  # @return the result of converting the pointer.
  def to_ruby ptr
    if type == :pointer
      return ptr

    # Types of FFI::Struct subclass are aliases for :pointer
    elsif (struct = type).respond_to?(:is_struct?)
      return ptr
    
    # Types of FFI::Union subclass are aliases for :pointer    
    elsif (union = type).respond_to?(:is_union?)
      return ptr
            
    # FFI::Struct#by_ref        
    elsif (instance = type).is_a?(FFI::Struct::ReturnAsInstance)
      struct = instance.klass
      return struct.new(ptr)
      
    # FFI::Union#by_ref      
    elsif (instance = type).is_a?(FFI::Union::ReturnAsInstance)
      union = instance.klass
      return union.new(ptr)      
      
    elsif e=FFI::Library.enums[type]
      q = ptr.value
      return e.find do |k,v|
        v == q
      end[0] || q
    
    elsif typedef = FFI::Library.typedefs[type]
      o_type = type
      self[:type] = typedef
      q = to_ruby(ptr)
      self[:type] = o_type
      return q
    
    else 
      tt = type
      return ptr.send(:"read_#{tt}")  
    
    end
  end
  
  # Determines if the corresponding type is numerical
  #
  # @return [TrueClass,FalseClass]
  def is_numeric?
    !!FFI::C_NUMERICS.index(FFI::TYPES[type])
  end
end 

# Represents paramater information and defines ways to create and convert them to/from c.
class Argument < Struct.new(:type,:value,:index)
  # Sets value from an argument passed to Function#invoke
  # 
  # @param v the ruby value to convert.
  def set v
    self[:value] = v
  end
  
  include FFIType2CFuncType
    
  include Cvalue2RubyValue
  
  # Creates an appropiate pointer for an Argument resolved by its `type` member.
  #   that is set by its `value` member
  #
  # @return a suitable pointer
  def for_invoke      
      enum_type = FFI::Library.enums[type]
      
      if enum_type
        CFunc::Int.new(enum_type[value])
      
      elsif type == :string
        value
        
      elsif (cfunc_type = FFI::TYPES[type])
        if (typedef = FFI::Library.typedefs[type])
          o_type = type
          self[:type] = typedef
          q = for_invoke()
          self[:type] = o_type
          return q
        end
  
        return cfunc_type.new(value)
      
      elsif (callback_type = FFI::Library.callbacks[type])
        FFI::Closure.new(*callback_type, &value)

      elsif (struct = type).respond_to?(:is_struct?)
        if value.is_a?(CFunc::Struct)
          return value.addr
        elsif value.is_a?(CFunc::Pointer)
          return value
        else
          return value
        end
  
      elsif (union = type).respond_to?(:is_union?)
        if value.is_a?(FFI::Union)
          return value.pointer
        elsif value.is_a?(CFunc::Pointer)
          return value
        else
          return value
        end
  
      elsif (instance = type).is_a?(FFI::Struct::ReturnAsInstance)
        struct = instance.klass
        
        if value.is_a?(struct)
          return value.addr
        
        elsif value.is_a?(CFunc::Pointer)
          return value
        
        else
          # FIXME: should probally raise
          return value
        
        end

      elsif (instance = type).is_a?(FFI::Union::ReturnAsInstance)
        union = instance.klass
        
        if value.is_a?(union)
          return value.pointer
        
        elsif value.is_a?(CFunc::Pointer)
          return value
        
        else
          # FIXME: should probally raise
          return value
        
        end
      
      else
        raise "Unsupported type: #{type}"
      end
  end
end


# Represents information of a return_value.
class Return < Struct.new(:type)
  include FFIType2CFuncType
  
  include Cvalue2RubyValue
  
  # @see Cvalue2RubyValue#to_ruby
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
