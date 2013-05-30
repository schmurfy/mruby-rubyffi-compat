module FFI
  class Struct < CFunc::Struct
    alias_method :pointer, :addr
    
    def array_members
      self.class.instance_variable_get("@array_members")
    end    
    
    def [] k
      if (map = (array_members || {})[k])
  t,s = map[0],map[1]
	ptr = super(k)
	CFunc::CArray(FFI.find_type(t)).refer(ptr.addr)
      else
	super
      end
    end  
   
    
    
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

        d[1] = FFI.find_type(d[1]) unless d[1].respond_to?(:"is_struct?")
        b.push(*d.reverse)
        d=[]
      end
      b
    end
  
    def self.layout *o
      l = nil
      n = o.map do |q|
	if q.is_a?(Array)
	  t = q[0]
	  s = q[1]
	  (@array_members ||= {})[l] = q
	  next(:pointer)
	else
	  l = q
	  next q
	end
      end
      
      define(*every(n,2))
    end
  end
  
  class Union < Struct
  end
    
end
