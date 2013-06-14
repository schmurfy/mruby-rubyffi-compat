mkdir tmp
cd tmp
git clone https://github.com/mruby/mruby.git
echo "MRuby::Build.new do |conf|
  toolchain :gcc
  conf.gembox 'default'
  conf.gem :github => 'mobiruby/mruby-cfunc', :branch => 'master'
end" > mruby/build_config.rb
cd mruby; make
cd ../..
