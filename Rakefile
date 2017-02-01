require 'cucumber/rake/task'
require 'erb'
require 'fileutils'
require 'open3'
require 'yaml'


@name = 'kodi'

@meta = YAML.load(File.read('metadata.yaml'))

desc 'prepare PKG distribution'
task :pkg do
  mkdir_p 'dist/pkg/kodi'
  cp('README', 'dist/pkg/kodi/README')
  code_files = FileList['src/*.sty', 'src/*.tex']
  code_template = File.read('HEADER.erb')
  code_renderer = ERB.new(code_template, 0, '<>')
  code_files.each do |filename|
    @filename = File.basename(filename)
    @source = File.read(filename)
    target_filename = "dist/pkg/kodi/#{File.basename(filename)}"
    puts "render #{filename} to #{target_filename}"
    File.write(target_filename, code_renderer.result)
  end
end

desc 'prepare TDS distribution'
task tds: [:pkg] do
  {
    'kodi.tex'         => 'tex/plain/kodi/',         # TeX include
    'kodi.sty'         => 'tex/latex/kodi/',         # LaTeX package
    't-kodi.tex'       => 'tex/context/third/kodi/', # ConTeXt module
    'tikzlibrarykodi*' => 'tex/generic/kodi/',       # common TikZ library
    'kodi-doc.tex'     => 'doc/generic/kodi/',       # documentation
    'kodi-doc.pdf'     => 'doc/generic/kodi/',       #   "
    'README.md'        => 'doc/generic/kodi/'        #   "
  }.each do |source_file, target_subdir|
    copy_with_path("dist/pkg/kodi/#{source_file}", "dist/tds/#{target_subdir}")
  end
end

desc 'Compress'
task compress: [:pkg, :tds] do
  Dir.chdir('dist/tds') do
    system('zip', '--recurse-paths', "../pkg/#{@name}.tds.zip", '.')
  end
  Dir.chdir('dist/pkg') do
    system('zip', '--recurse-paths', "../#{@name}.zip", '.')
  end
end

desc 'Build'
task build: [:pkg, :tds, :compress]

def copy_with_path(mask, path)
  mkdir_p(path)
  cp_r(Dir[mask], path)
end

# desc 'Prepare package'
# task :ctanify do
#   `ctanify --pkgname mypkg dummy.tex`
# end

desc 'Upload'
task :ctanupload do
  # puts Open3.capture3(@meta['ctan'], 'ctanupload')
end

task :features, :feature, :setup do |_task, args|
  feature = args[:feature] || ''

  options = [
    # '--dry-run',
    # '--format progress'
    '--format pretty'
  ]

  if feature.include? 'generic'
    setup = args[:setup] || 'tex'
    setup = YAML.safe_load(File.read('features/support/workflows.yaml'))[setup]
    options += [
      "DIALECT=#{setup['dialect']}",
      "PIPELINE=#{setup['pipeline']}"
    ]
  end

  target = "features/#{feature}"
  if File.file?("#{target}.feature")
    target += '.feature'
  elsif !File.exist?(target.to_s)
    raise 'Invalid feature name.'
  end

  options += [
    target.to_s
  ]

  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.cucumber_opts = options
  end

  Rake::Task[:cucumber].invoke
end

require 'rake/clean'
CLEAN.include 'dist/pkg', 'dist/tds'
CLOBBER.include 'dist'

desc 'Install locally'
task install: :tds do
  basedir = `kpsexpand '$TEXMFHOME'`.chomp
  cp_r 'dist/tds/.', basedir
end

desc 'Uninstall locally'
task :uninstall do
  basedir = `kpsexpand '$TEXMFHOME'`.chomp
  [
    'tex/plain/kodi/',         # TeX include
    'tex/latex/kodi/',         # LaTeX package
    'tex/context/third/kodi/', # ConTeXt module
    'tex/generic/kodi/',       # common TikZ library
    'doc/generic/kodi/'        # documentation
  ].each do |subfolder|
    rm_rf "#{basedir}/#{subfolder}"
  end
end

desc 'Reinstall locally'
task reinstall: [:uninstall, :install]

desc 'Compile minimal koDi/standalone format'
task format: :install do
  stdout, stderr, status = Open3.capture3(
    'pdftex',
    '-ini',
    '&latex kodi-livedemo.tex\dump',
    '--output-directory dist'
  )
  puts stdout, stderr
  rm('kodi-livedemo.log')
  mv('kodi-livedemo.fmt', 'dist')
end
