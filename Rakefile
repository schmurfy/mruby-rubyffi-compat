
task :default => :mrbtest
#
# build a single big file for
# easier debugging with Mruby
# 
task :mrbpack do
  # read $mrbfiles
  load(File.expand_path('../mrbgem.rake', __FILE__))
  target_files = $mrbfiles
  
  target_files.unshift File.expand_path('../specs/init.rb', __FILE__)
  
  
  %w(
    tool.rb
    basic_spec.rb
    enum_spec.rb
  ).each do |path|
    target_files << File.expand_path("../specs/#{path}", __FILE__)
  end
  
  FileUtils.mkdir_p('tmp')
  cd 'tmp' do
    File.open('blob.rb', 'w') do |f|
      target_files.each do |path|
        f.puts "# #{path} ==============="
        f.write( File.read(path) )
        f.puts
        f.puts
      end
    end
  end
end


task :mrbtest => :mrbpack do
  # replace ourself with mruby process
  system('mruby tmp/blob.rb')
end

file 'specs/libtest/libtest.dylib' => ["specs/libtest/libtest.c"] do
  sh "gcc -dynamiclib -o specs/libtest/libtest.dylib specs/libtest/libtest.c"
end

