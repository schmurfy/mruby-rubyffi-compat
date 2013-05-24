module FFITests
  module TestLib
    enum :day, [:sunday, 1,
                :monday,
                :tuesday,
                :wednesday,
                :thursday,
                :friday,
                :saturday ]

    attach_function :is_work_day, [ :day ], :int
    
  end
end

header "Enum tests"

should 'accept symbol as enum argument' do
  eq(0, FFITests::TestLib.is_work_day(:sunday))
  eq(0, FFITests::TestLib.is_work_day(:saturday))
  eq(1, FFITests::TestLib.is_work_day(:tuesday))
end
