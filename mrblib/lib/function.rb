class Function
  attr_reader :return_type

  def initialize(lib, name, args, return_type)
    @arguments = args
    @lib = lib
    @name = name
    @return_type = return_type
  end
  
  
  def get_return_type
    return @return_type.get_c_type
  end
  
  attr_reader :arguments

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
      r = CFunc::libcall2(get_return_type,@where,@name.to_s,*invoked)
      
      arguments.each do |a|
	a.set nil
      end
      
      return(@return_type.type == :void ? nil : @return_type.to_ruby(r))
  end

  def invoke(*args, &b)
    call *args,&b
  end
end







