lib_root = File.expand_path('../mrblib', __FILE__)

$mrbfiles = []
$rbfiles = [
  'lib/types',
  'lib/argument',
  'lib/closure',
  'lib/function',
  'lib/library',
  'lib/pointer',
  'lib/struct',
  'lib/union',  
  'lib/dynamic_library',
  'ffi'
]

$rbfiles.each do |path|
  $mrbfiles << File.join(lib_root, "#{path}.rb")
end

if defined?(MRuby)
  MRuby::Gem::Specification.new('mruby-rubyffi-compat') do |spec|
    spec.license = 'MIT'
    spec.authors = ['Julien Ammous', 'ppibburr']
    spec.version = "0.0.1"
    
    spec.rbfiles = $mrbfiles
    
    spec.add_dependency('mruby-cfunc', '>= 0.0.0')
  end
end
