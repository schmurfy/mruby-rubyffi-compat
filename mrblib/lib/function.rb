module FFI
  # Describes a FFI::Function
  class FunctionType
    attr_accessor :param_types,:return_type
    def initialize rt,pta
      @param_types = pta
      @return_type = rt
    end
  end
end

module FFI
  # Represents a Function that can be invoked
  class Function
    attr_accessor :function_type,:invoker,:address
    
    # @param rt [Symbol] that can be resolved to a type that describes the return type.
    # @param pta [Array] of Symbol's that can be resolved to a type that describe the parameter types.
    # @param addr [Array] of [DynamicLibrary,String] that describes where to find the function.
    def initialize rt,pta,addr
      @address = addr
      @function_type = FunctionType.new(rt,pta)
    end
    
    # Calls the function represented passing params.
    #
    # @return the result of calling the function.
    def invoke *o,&b
      @invoker ||= create_invoker()
      invoker.invoke *o,&b
    end
    
    alias :call :invoke
    
    # Binds function by defining a method on `where` to `name`.
    #
    # @param where where to bind the function.
    # @param name [String,Symbol] of the method name. 
    def attach where,name
      this = self
      where.singleton_class.define_method(name) do |*args, &b|  
	this.invoke(*args, &b)
      end
    end  
    
    # Creates a FFICompat::FunctionInvoker.
    #
    # @return [FFICompat::FunctionInvoker] that was created
    def create_invoker()
      ft = function_type
      rt,pta = ft.return_type,ft.param_types
      
      i=0
      args = pta.map do |a|
      
	arg=Argument.new
	arg[:index] = i
	
	i=i+1
	
	arg[:type] = a  

	arg
      end
      
      rett = Return.new
      

      rett[:type] = rt
      
      address[0].send(:get_symbol,address[1])
      
      @invoker = FFICompat::FunctionInvoker.new(address[0], address[1], args, rett)
    end  
  end
end

module FFICompat
  # Represents a function suitable for using with CFunc
  class FunctionInvoker
    def initialize(lib, name, args, return_type)
      @arguments = args
      @lib = lib
      @name = name
      @return_type = return_type
    end
    
    # @return the absolute type of the Return
    def get_return_type
      return @return_type.get_c_type
    end
    
    attr_reader :arguments

    # Invokes the function passing paramaters. 
    #
    # @return the result of calling the function
    def call *o
      raise ArgumentError.new("#{o.length} for #{arguments.length}") unless o.length == arguments.length

      invoked = []
      
      arguments.each_with_index do |a,i|
	a.set o[i]
	
	ptr = a.for_invoke
	
	if a.value == nil
	  # do not wrap nil, pass it as is !
	  invoked << nil
	else
	  invoked << ptr
	end
      end

      # call the function
      r = @lib.call(get_return_type,@name.to_s,*invoked)
      
      arguments.each do |a|
	a.set nil
      end
      
      return(@return_type.type == :void ? nil : @return_type.to_ruby(r))
    end

    # @see #call
    def invoke(*args, &b)
      call(*args, &b)
    end
  end
end
