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

    def call(result_type, func_name, *args)
      # @dlh ||= CFunc[:dlopen].call(@libname,CFunc::Int.new(1))
      
      f = @funcs[func_name]
      unless f
        fun_ptr = CFunc::call(CFunc::Pointer, :dlsym, @dlh, func_name)
        f = CFunc::FunctionPointer.new(fun_ptr)
        f.result_type = result_type
        @funcs[func_name] = f
      end
      
      # f.arguments_type = args.map do |a| a.class end
      f.arguments_type = args.map{|a| a.class }
      return f.call(*args)
    end
    
    def self.for(libname)
      if n = @@instances[libname]
        n
      else
        new(libname)
      end
    end
  end
  
  def self.libcall2(result_type, libname, func_name, *args)
    CFunc::Library.for(libname).call(result_type, func_name, *args)
  end
end
