require 'open3'

#==[ rake ]=====================================================================

# Reinstall koDi locally at any change of non-doc source file.

guard 'rake', :task => 'install' do
  watch(%r{^src/tikzlibrarykodi..+.code.tex$})
  watch('kodi.tex')
  watch('kodi.sty')
  watch('t-kodi.tex')
end

#==[ cucumber ]=================================================================

cucumber_options = {
  cmd_additional_args: '--no-profile --color --format pretty --no-source',
  all_on_start: false
}

# We test the features of any generic module on source modification.
# This runs just with TeX - it's meant for quick checking during code writing.

def core_dependants_of(name)
  dependencies = {}
  Dir['src/tikzlibrarykodi.*.code.tex'].each do |filename|
    code = File.read filename
    sublibrary_name = filename[/kodi\.(.*)\.code/, 1]
    usetikzlibrary = /\\usetikzlibrary[\[{]kodi\.(\w+)[\]}]/
    dependencies[sublibrary_name] = code.scan(usetikzlibrary).map(&:first)
  end
  dependants = []
  upper_level = [name]
  until upper_level.empty?
    dependants.concat upper_level
    upper_level = []
    dependants.each do |d|
      upper_level.concat dependencies.select { |_, ds| ds.include? d }.keys
    end
    upper_level.reject! { |x| dependants.include? x }
  end
  dependants
end

guard 'cucumber', cucumber_options do
  ENV['DIALECT'] = 'tex'
  ENV['PIPELINE'] = 'tex'
  watch(%r{^src/tikzlibrarykodi\.(.+)\.code\.tex$}) do |m|
    core_dependants_of(m[1]).map { |n| "features/generic/#{n}" }
                            .select { |f| File.exist? f }
  end
end

guard 'cucumber', cucumber_options do
  ENV['DIALECT'] = 'tex'
  ENV['PIPELINE'] = 'tex'
  watch(%r{^features/.+\.feature$})
end

#==[ doc compilation ]==========================================================

guard 'rake', :task => 'doc' do
  watch(%r{^doc/.+\.tex})
end

guard :shell do
  watch(%r{doc/(kodi-doc.tex)}) do |m|
    commandline = ['latexmk', '-pdf', m[1]]
    _stdout, _stderr, status = Open3.capture3(*commandline, chdir: './doc')
    # return false unless status.success?
  end
end
