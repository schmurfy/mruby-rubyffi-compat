
class Array
  def find_all_indices a=self,&b
    o = []
    a.each_with_index do |q,i|
      if b.call(q)
        o << i
      end
    end
    return o
  end
  
  def flatten
    a=[]
    each do |q|
      a.push(*q)
    end
    return a
  end  
end

module FFI
  def self.errno
    return CFunc.errno
  end  
end

