module FFICompat
  # Represents a library to load
  class DynamicLibrary
    attr_reader :dlh, :libname
    
    def initialize(libname)
      @funcs = {}
      @libname= libname
      if @libname.to_s == 'c'
        @libname = nil
      end
      
      @dlh = CFunc::call(CFunc::Pointer, "dlopen", @libname, CFunc::Int.new(1))
    end
    
    # sanity
    #
    # @return [Boolean] true if the handle is non-null
    def exist?
      !@dlh.is_null?
    end
    
    # Calls a function in the library
    #
    # @param args [Array] of CFunc::Pointer's any of (struct, numerical, pointer, string)
    # @param func_name [#to_s] of the function name to call
    # @param result_type the type of result (any of CFunc::Pointer,CFunc::Struct,CFunc::CArray,a and the numerical types, ie CFunc::Int)
    # @return an instance of the +result_type+ of the result of calling the function
    def call(result_type, func_name, *args)
      f = @funcs[func_name]
      unless f
        fun_ptr = get_symbol(func_name)
        f = CFunc::FunctionPointer.new(fun_ptr)
        f.result_type = result_type 
        @funcs[func_name] = f
      end

      f.arguments_type = args.map do |a| a.class end
      f.call(*args)
    end
    
    # get a symbol in the libray of +name+
    #
    # @param name [#to_s] of the symbol to get
    # @return CFunc::Pointer
    def get_symbol(name)
      CFunc::call(CFunc::Pointer, :dlsym, @dlh, name.to_s)
    end
    
    # finds a symbol of +name+
    #
    # @param name [#to_s] name of the symbol
    # @return [Array,NilClass] if the symbol was found returns Array of [self,name], otherwise nil
    def find_symbol name
      if !(s=get_symbol(name)).is_null?
        return [self,name]
      end
    end
  end
end
