module FFITests
  module TestLib
    enum :day, [:sunday, 1,
                :monday,
                :tuesday,
                :wednesday,
                :thursday,
                :friday,
                :saturday ]

    attach_function :is_work_day, [ :day ], :bool
    attach_function :my_favorite_day,[],:day
    
  end
end

header "Enum tests"

should 'accept symbol as enum argument' do
  assert_false FFITests::TestLib.is_work_day(:sunday)
  assert_false FFITests::TestLib.is_work_day(:saturday)
  assert_true  FFITests::TestLib.is_work_day(:tuesday)
end

should 'allow enum as return' do
  eq :saturday,FFITests::TestLib.my_favorite_day()
end
