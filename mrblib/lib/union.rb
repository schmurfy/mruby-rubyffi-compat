module FFI
  # Implements union types. 
  class Union
    # Used to implement Union.by_ref in the specification of types
    class ReturnAsInstance
      attr_reader :klass
      
      # @param struct [FFI::Union] subclass to point to
      def initialize union
        @klass = union
      end
    end
    
    # Used in detection via `respond_to?`
    #
    # @return true
    def self.is_union?
      true
    end
    
    # @return [FFI::Union::ReturnAsInstance] pointing to self
    def self.by_ref
      ReturnAsInstance.new(self)
    end

    def self.layout *a
      map = {}
      
      cnt = -1
      
      l = nil
      
      a.each do |q|
        cnt += 1
        
        if cnt >= 1
          map[l] = Class.new(FFI::Struct)
          map[l].layout l,q
        
          cnt = -1
        end
        
        l = q
      end
      
      @_members_ = map    
    end
    
    def [] k
      self.class.members[k].new(@ptr)[k]
    end
    
    def []= k,v
      self.class.members[k].new(@ptr)[k]=v
    end  
    
    def self.members
      @_members_
    end
    
    def members
      self.class.members
    end
    
    def initialize ptr
      @ptr = ptr
    end
    
    def pointer
      @ptr
    end
  end
end
