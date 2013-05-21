class Symbol
  def enum?
    return FFI::Library.enums[self]
  end
end
