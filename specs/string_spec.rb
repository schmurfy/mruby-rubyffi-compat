module FFITests
  module TestLib    
    attach_function :save_string, [:string], :void
    attach_function :get_char, [:uint], :uint
  end
end

header "String tests"

should 'save string' do
  FFITests::TestLib.save_string("hi there")
  c = FFITests::TestLib.get_char(0)
  eq(c, "h".bytes[0].to_i)
end
