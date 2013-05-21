module CFunc
  define_function CFunc::Pointer,"dlopen",[CFunc::Pointer,CFunc::Int]
  class Library
    @@instances = {}
    def initialize where
      @funcs = {}
      @@instances[where] = self
      @libname=where
      if @libname.to_s == 'c'
        @libname = nil
      end
      
      @dlh = CFunc::call(CFunc::Pointer, "dlopen", @libname, CFunc::Int.new(1))
    end

    def call rt,name,*args
      # @dlh ||= CFunc[:dlopen].call(@libname,CFunc::Int.new(1))
      if !(f=@funcs[name])
        fun_ptr = CFunc::call(CFunc::Pointer,:dlsym,@dlh,name)
        f = CFunc::FunctionPointer.new(fun_ptr)
        f.result_type = rt
        @funcs[name] = f
      end
      
      f.arguments_type = args.map do |a| a.class end      
      return f.call(*args)
    end
    
    def self.for where
      if n=@@instances[where]
        n
      else
        return new(where)
      end
    end
  end
  
  def self.libcall2 rt,where,n,*o
    return CFunc::Library.for(where).call rt,n,*o
  end
end
