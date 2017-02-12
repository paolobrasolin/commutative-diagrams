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

guard 'cucumber', cucumber_options do
  ENV['DIALECT'] = 'tex'
  ENV['PIPELINE'] = 'tex'
  watch(%r{^src/tikzlibrarykodi\.(.+)\.code\.tex$}) do |m|
    "features/generic/#{m[1]}"
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

# guard :shell do
#   watch(%r{doc/(kodi-doc.tex)}) do |m|
#     commandline = ['latexmk', '-pdf', m[1]]
#     _stdout, _stderr, status = Open3.capture3(*commandline, chdir: './doc')
#     # return false unless status.success?
#   end
# end
