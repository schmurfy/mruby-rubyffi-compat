
guard 'rake', :task => 'mrbtest' do
  watch(%r{^mrblib/(.+)\.rb$})
  watch(%r{^specs/(.+)\.rb$})
  watch(%r{^specs/libtest/libtest.dylib})
end

guard 'rake', task: 'libtest' do
  watch(%r{^specs/libtest/libtest.c})
end
