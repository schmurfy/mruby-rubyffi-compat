
module FFI
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
  
  def self.find_type t
    return FFI::TYPES[t] || CFunc::Pointer
  end  

  def self.type_size t
    return FFI::TYPES[t].size
  end

end

module FFIType2CFuncType
  # Returns a Class of CFunc namespace types
  def ffi_type
    case type
    when :object
      CFunc::Pointer
    when :struct
      CFunc::Pointer
    when :union
      CFunc::Pointer
    when :array
      CFunc::CArray(array.ffi_type)
    else
      FFI::TYPES[type] || CFunc::Pointer
    end
  end
end
