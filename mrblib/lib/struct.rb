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

        d[1] = FFI.find_type(d[1]) unless d[1].respond_to?(:"is_struct?") || d[1].is_a?(CFunc::CArray)
        b.push(*d.reverse)
        d=[]
      end
      b
    end
  
    def self.layout *o
      define(*every(o,2))
    end
  end
  
  class Union < Struct
  end
    
end
