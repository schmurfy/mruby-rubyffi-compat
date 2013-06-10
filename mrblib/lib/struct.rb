module FFI
  class Struct < CFunc::Struct
    # Used to implement Struct.by_ref in the specification of types
    class ReturnAsInstance
      attr_reader :klass
      
      # @param struct [FFI::Struct] subclass to point to
      def initialize struct
	@klass = struct 
      end
    end
    
    alias_method :pointer, :addr
    
    # @return [Array] of field names
    def self.members
      elements.map{|e| e[1] }
    end
    
    # Used in detection via `respond_to?`
    #
    # @return true
    def self.is_struct?
      true
    end
    
    # @return [ReturnAsInstance] pointing to self
    def self.by_ref
      ReturnAsInstance.new(self)
    end
    
    class << self
      attr_reader :string_members  
      attr_reader :array_members
    end
    
    def self.every(a,i)
      b=[]
      q=a.clone
      d=[]
      c=0
      until q.empty?
        for n in 0..i-1
          d << q.shift
        end

        if d[1].is_a?(Array)
	  type = FFI.find_type(t=d[1][0])
	  size = d[1][1]
	  d[1] = type[size]
	  (@array_members ||={})[d[0]] = [t,size]

	end
	
	if d[1] == :string
	  (@string_members ||=[]) << d[0]
	end

        d[1] = FFI.find_type(d[1]) unless d[1].respond_to?(:"is_struct?") || d[1].is_a?(CFunc::CArray)
        b.push(*d.reverse)
        d=[]
      end
      b
    end

    alias :_get_member :"[]"
    
    def [] k    
      q = _get_member(k)
      field = lookup(k)
      
      # TODO: thus far field[3] memeber of :new is only way to detect
      if field[3] == :new
	cls = InlineArray
	
	if field[0].type == CFunc::UInt8
	  cls = CharArray
	end
	
	s = self.class.array_members[k][1]

	return cls.new(q,s) 
      end
      
      if sma=self.class.string_members
	if sma.index(k)
	  return q.to_s
	end
      end
      
      return q
    end

    # Describe the structure
    def self.layout *o
      define(*every(o,2))
    end
  end
  
  # TODO: just a struct, kinda works
  class Union < Struct
  end
    
end

# Represents an array member of an FFI::Struct
class FFI::Struct::InlineArray
  include Enumerable
  
  # @param ptr the pointer to wrap
  def initialize ptr,size
    @pointer = ptr
    @size = size
  end
  
  def to_ptr
    @pointer
  end
  
  def each
    for i in 0..@size-1
      q = to_ptr[i].value 
      yield q
    end
  end
  
  def []= i,v
    to_ptr[i].value = v	
  end
  
  def [] i
    to_ptr[i].value	
  end
  
  # @return the rsult of calling `to_s` the wrapped pointer
  def to_s
    to_ptr.to_s
  end
end

class FFI::Struct::CharArray < FFI::Struct::InlineArray
end