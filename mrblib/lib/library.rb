module FFI
  module Library
    # @param [Array] names names of libraries to load
    # @return [Array<FFICompat::DynamicLibrary>]
    # @raise if a library cannot be opened
    # Load native libraries.    
    def ffi_lib(libnames)
      @ffi_libs ||= []
      libnames = [libnames] unless libnames.is_a?(Array)
      libnames.each do |libname|
	lib = FFICompat::DynamicLibrary.new(libname)
	
	if lib.exist? || (libnames[0] == :c)
	  @ffi_libs << lib
	end
      end
	  
      if @ffi_libs.empty?
	raise "library not found: #{libnames}"
      end
      
      @ffi_libs
    end
    
    @@callbacks = {}
    def callback(name, arguments_type, result_type)
      @@callbacks[name] = [ arguments_type.map{|t| FFI::TYPES[t]}, FFI::TYPES[result_type] ]
    end
    
    def self.callbacks
      @@callbacks
    end
    

    @@typedefs = {}
    def typedef(type_name, alias_name)
      @@typedefs[alias_name] = type_name
      FFI::TYPES[alias_name] = FFI.find_type(type_name)
    end  
    
    def self.typedefs
      @@typedefs
    end
    
    @@enums = {}
    def enum(enum_name, arr)
      idx = 0
      values = {}
      
      pos = 0
      loop do
	name = arr[pos]
	value = arr[pos+1]
	
	if value.is_a?(Integer)
	  idx = value
	  pos += 2
	else
	  pos += 1
	end
	
	values[name] = idx
	idx += 1
	
	break if pos >= arr.size
      end
      
      @@enums[enum_name] = values
      typedef(:int, enum_name)
      
      self
    end

    def self.enums
      @@enums
    end  
    
    # @example attach function without an explicit name
    #   module Foo
    #     extend FFI::Library
    #     ffi_lib FFI::Library::LIBC
    #     attach_function :malloc, [:size_t], :pointer
    #   end
    #   # now callable via Foo.malloc    
    # Attach C function +func+ to this module.
    #
    #
    # @param [#to_s] name name of ruby method to attach as
    # @param [#to_s] func name of C function to attach
    # @param [Array<Symbol>] args an array of types
    # @param [Symbol] returns type of return value
    #
    # @return [FFI::Function]    
    def attach_function(function_name, arguments_type, result_type)
      lib = @ffi_libs.find do |l|
	l.send(:get_symbol,function_name)
      end
      
      f = Function.new(result_type, arguments_type,[lib,function_name])

      f.attach(self,function_name)
      
      f
    end
    
  end
end
