module FFI
  class FFI::Closure < CFunc::Closure
    # CLOSURES = {}
      
    # def self.add name,rt,at,&b
    #   return FFI::Closure::CLOSURES[name] ||= FFI::Closure.new(rt,at,&b)
    # end
  end
  
  # class DefaultClosure < FFI::Closure
  #   def initialize &b
  #     super CFunc::Void,[],&b
  #   end
  # end
end
