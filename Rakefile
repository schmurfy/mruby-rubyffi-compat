
task :default => :mrbtest
#
# build a single big file for
# easier debugging with Mruby
# 
task :mrbpack do
  # read $mrbfiles
  load(File.expand_path('../mrbgem.rake', __FILE__))
  target_files = $mrbfiles
  
  test_file_path = File.expand_path('../mruby_test.rb', __FILE__)
  if File.exist?(test_file_path)
    target_files << test_file_path
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
  Process.exec('mruby tmp/blob.rb')
end

