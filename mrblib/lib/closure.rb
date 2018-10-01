module FFI8
  # Helps turn a block into a callback  
  CLOSURES = []
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
  
      cb = Proc.new do |*a,&c|
        aa = []
        
        a.each_with_index do |q,i|
          aa << ptypes[i].to_ruby(FFI::Pointer.refer(q.addr))
        end
        
        # HACK: b goes nil in a GSourceFunc after the function yielded false (told to stop)
        # FIXME: when mruby writes a bunch to STDOUT segfaults happen
        #        This happens elsewhere, maybe bug mruby ...
        next() unless b
        
        b.call(*aa,&c)
      end

      FFI8::CLOSURES << cb

      super rt,ptypes_c , &cb
    end
  end
end
