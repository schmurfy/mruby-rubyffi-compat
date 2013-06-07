
module FFI
  # A list of numerical c types in CFunc
  C_NUMERICS = [
    CFunc::Int,
    CFunc::SInt8,
    CFunc::SInt16,
    CFunc::SInt32,
    CFunc::SInt64,
    CFunc::UInt32,
    CFunc::UInt8,
    CFunc::UInt16,
    CFunc::UInt32,
    CFunc::UInt64,
    CFunc::Float,
    CFunc::Double
  ]
  
  # A map of types from Symbol and thier CFunc equivalants
  TYPES = {
    :self     => :pointer,
    :int      => CFunc::Int,
    :uint     => CFunc::UInt32,
    :bool     => CFunc::Int,
    :string   => CFunc::Pointer,
    :pointer  => CFunc::Pointer,
    :void     => CFunc::Void,
    :double   => CFunc::Double,
    :size_t   => CFunc::UInt32,
    :ulong    => (FFI.longsize == 8) ? CFunc::UInt64 : CFunc::UInt32,
    :long     => (FFI.longsize == 8) ? CFunc::SInt64 : CFunc::SInt32,
    :uint64   => CFunc::UInt64,
    :uint8    => CFunc::UInt8,
    :uint16   => CFunc::UInt16,
    :uint32   => CFunc::UInt32,
    :int64    => CFunc::SInt64,
    :int16    => CFunc::SInt16,
    :int8     => CFunc::SInt8,
    :int32    => CFunc::Int,
    :short    => CFunc::SInt16,
    :ushort   => CFunc::UInt16,
    :callback => CFunc::Closure,
    :struct   => CFunc::Pointer,
    :array    => CFunc::CArray
  }
  
  # @param [Symbol] name
  # @return the resolved class for CFunc
  # Find a type from symbol
  def self.find_type t
    return FFI::TYPES[t] || CFunc::Pointer
  end  

  # Find the size of a type
  # @param t [Symbol] of the type to resolve
  # @return [Integer] size of type +t+
  def self.type_size t
    return FFI::TYPES[t].size
  end

end

module FFIType2CFuncType
  #  Find the absolute c_type
  #  FFI::Struct's are resolved to CFunc::Pointer
  #  FFI::Struct::ReturnAsInstance's are resolved to the FFI::Struct they represent
  #
  # @return the absolute type
  def get_c_type
    return FFI::TYPES[type] || (type.respond_to?(:is_struct?) ? CFunc::Pointer : (type.is_a?(FFI::Struct::ReturnAsInstance) ? type.klass : nil))
  end
  
end
