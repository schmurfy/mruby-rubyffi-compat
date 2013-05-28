module FFICompat
  
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
    
    def exist?
      !@dlh.is_null?
    end
    
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
    
    def create_function(name,at,rt)
      i=0
      args = at.map do |a|
      
        arg=Argument.new
        arg[:index] = i
        
        i=i+1
        
        arg[:type] = a  

        arg
      end
      
      rett = Return.new
      

      rett[:type] = rt
      
      Function.new(self, name, args, rett)
    end
    
    
  # private
    def get_symbol(name)
      CFunc::call(CFunc::Pointer, :dlsym, @dlh, name)
    end
    
  end
  
end
