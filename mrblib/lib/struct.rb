module FFI
  class Struct < CFunc::Struct
    alias_method :pointer, :addr
    
    def self.members
      elements.map{|e| e[1] }
    end
    
    def self.is_struct?
      true
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
	  type = FFI.find_type(d[1][0])
	  size = d[1][1]
	  d[1] = type[size]
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
	return InlineArray.new(q) 
      end
      
      return q
    end

    def self.layout *o
      define(*every(o,2))
    end
  end
  
  class Union < Struct
  end
    
end

class FFI::Struct::InlineArray
  def initialize ptr
    @pointer = ptr
  end
  
  def to_ptr
    @pointer
  end
  
  def [] i
    to_ptr[i].value
  end
  
  def []= i,v
    to_ptr[i].value = v
  end
  
  def to_array
    a = []
    for i in 0..to_ptr.class.size-1
      a << to_ptr[i].value
    end
    
    # MRI ffi gem does not return the trailing null in the array
    if a.last == 0 then a.pop end
    
    return a
  end
  
  def to_a
    to_array
  end
  
  def to_s
    to_ptr.to_s
  end
end
