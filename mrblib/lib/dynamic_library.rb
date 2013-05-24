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
    
    def create_function(name,at,rt,ret=[-1])
      i=0
      args = at.map do |a|
      
        arg=Argument.new
        arg[:index] = i
        i=i+1
        direction,array,type,error,callback,data,allow_null = :in,false,:pointer,false,false,false ,false 
        
        while a.is_a?(Hash)
          case a.keys[0]
          when :out
            direction = :out
          when :inout
            direction = :inout
          when :allow_null
            allow_null = true
          when :callback
            callback = a[a.keys[0]]
          else
          end
          
          a = a[a.keys[0]]
        end
        
        if a.is_a? Array
          array = ArrayStruct.new
          arg[:array][:type] = a[0]
          a = :array
        end
        

        type = a
        arg[:type] = type    
        arg[:direction] = direction
        arg[:allow_null] = allow_null
        arg[:callback] = callback
        arg
      end
      
      interface = false
      array = false
      object = false
      
      rett = Return.new
      
      while rt.is_a? Hash
        case rt.keys[0]
        when :struct
          rett[:struct] = rt[rt.keys[0]]
          rett[:type] = :struct
          rt = nil
        when :object
          rett[:object] = rt[rt.keys[0]]
          rett[:type] = :object
          rt = nil
        end
        rt = rt[rt.keys[0]]
      end
      
      if rt.is_a? Array
        ret[:type] = :array
        ret[:array] = ArrayStruct.new
        ret[:array][:type] = rt[0]
      elsif rt
        rett[:type] = rt
      end
      
      Function.new(self, name, args, rett, ret)
    end
    
    
  # private
    def get_symbol(name)
      CFunc::call(CFunc::Pointer, :dlsym, @dlh, name)
    end
    
  end
  
end
