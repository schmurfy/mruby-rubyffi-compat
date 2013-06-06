module FFI
  # This module is the base to use native functions.  
  #
  # A basic usage may be:  
  # @example
  #   module MyLib
  #     extend FFI::Library
  #     ffi_lib 'c'
  #     attach_function :puts, [ :string ], :int
  #   end
  #
  #    MyLib.puts 'Hello, World using libc!'
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
    
    # Add a callback
    # @param name [Symbol] to map to
    # @param arguments_type [Array<Symbol,FFI::Struct,FFI::Struct::ReturnAsInstance>] of the parameter types
    # @param result_type [Symbol,FFI::Struct,FFI::Struct::ReturnAsInstance] of the return type
    # @return [Array] representing the callback
    # @example
    #    # has Integer as paramater and returns boolean
    #    callback(:SomeLibCallback,[:int],:bool)
    #    # SomeFoo is a FFI::Struct
    #    # SomeFoo resolves to :pointer as parameter and returns Integer
    #    callback(:SomeFooCallback,[SomeFoo],:int)
    #    # No parameters, returns an instance of SomeOtherFoo wrapped to the resulting pointer
    #    callback(:SomeOtherFooCallback,[],SomeOtherFoo.by_ref)
    # TODO: implement structs as types
    def callback(name, arguments_type, result_type)
      @@callbacks[name] = [ arguments_type.map{|t| FFI::TYPES[t]}, FFI::TYPES[result_type] ]
    end
    
    # @return [Hash] of the callbacks
    def self.callbacks
      @@callbacks
    end
    

    @@typedefs = {}
    
    # Adds a typdef
    # @param type_name [Symbol,FFI::Struct] to alias against
    # @param alias_name [Symbol] to map to
    # @return the resolved type class
    def typedef(type_name, alias_name)
      @@typedefs[alias_name] = type_name
      FFI::TYPES[alias_name] = FFI.find_type(type_name)
    end  
    
    # @return [Hash] of the typedefs
    def self.typedefs
      @@typedefs
    end
    
    @@enums = {}
    
    # Add a enum map
    # @param name [Symbol] to map the enum to
    # @param arr [Array<Symbol>,Array<Mixed>] of the enum members
    # @example
    #   enum(:Foo,[:bar,:quux,:moof])
    #   enum(:Foo,[3,:moof,4,:quux])
    # @return self
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

    # @return [Hash] of the added enums
    def self.enums
      @@enums
    end  
    
    # @example attach function without an explicit name
    #   module Foo
    #     extend FFI::Library
    #     ffi_lib FFI::Library::LIBC
    #     attach_function :malloc, [:size_t], :pointer
    #
    #     # has Integer as paramater and returns boolean
    #     attach_function(:foo,[:int],:bool)
    #
    #     # SomeFoo is a FFI::Struct
    #     # SomeFoo resolves to :pointer as parameter and returns Integer
    #     attach_function(:bar,[SomeFoo],:int)
    #   
    #     # No parameters, returns an instance of SomeOtherFoo wrapped to the resulting pointer
    #     attach_function(:moof,[],SomeOtherFoo.by_ref)
    #   end
    #   # now callable via Foo.malloc    
    # Attach C function +func+ to this module.
    #
    #
    # @param [#to_s] name name of ruby method to attach as
    # @param [#to_s] func name of C function to attach
    # @param [Array<Symbol,FFI::Struct,FFI::Struct::ReturnAsInstance>] args an array of types
    # @param [Symbol,FFI::Struct,FFI::Struct::ReturnAsInstance] returns type of return value
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
