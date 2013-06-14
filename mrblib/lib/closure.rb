module FFI8
  # Helps turn a block into a callback  
  class FFI::Closure < CFunc::Closure
    def initialize args,r,&b
      ptypes = args.map do |a|
        arg = Argument.new()
        arg[:type] = a
        arg
      end
     
      ptypes_c = ptypes.map do |a|
        a.get_c_type
      end
      
      rtt = Return.new
      rtt[:type] = r
      rt = rtt.get_c_type

      super rt,ptypes_c do |*a,&c|
        aa = []
        a.each_with_index do |q,i|
          aa << ptypes[i].to_ruby(FFI::Pointer.refer(q.addr))
        end
        
        b.call(*aa,&c)
      end
    end
  end
end
