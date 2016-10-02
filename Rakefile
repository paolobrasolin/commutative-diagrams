require 'fileutils'
require 'open3'

@name = 'kodi'

require 'erb'

require 'yaml'

@meta = YAML.load(File.read('metadata.yaml'))

desc 'Prepare PKG'
task :pkg do
  mkdir_p 'dist/pkg/kodi'
  cp('README', 'dist/pkg/kodi/README')
  source_files = FileList['src/*.sty', 'src/*.tex']
  source_template = File.read('HEADER.erb')
  source_renderer = ERB.new(source_template, 0, '<>')
  source_files.each do |filename|
    @filename = File.basename(filename)
    @source = File.read(filename)
    target_filename = "dist/pkg/kodi/#{File.basename(filename)}"
    puts "render #{filename} to #{target_filename}"
    File.write(target_filename, source_renderer.result)
  end
end

desc 'Prepare TDS'
task :tds => :pkg do
  {
    'kodi.tex'         => 'tex/plain/kodi/',         # TeX include
    'kodi.sty'         => 'tex/latex/kodi/',         # LaTeX package
    't-kodi.tex'       => 'tex/context/third/kodi/', # ConTeXt module
    'tikzlibrarykodi*' => 'tex/generic/kodi/',       # common TikZ library
    'kodi-doc.tex'     => 'doc/generic/kodi/',       # documentation
    'kodi-doc.pdf'     => 'doc/generic/kodi/',       #  "
    'README.md'        => 'doc/generic/kodi/'        #  "
  }.each do |source_files, target_dir|
    copy_with_path("dist/pkg/kodi/#{source_files}", "dist/tds/#{target_dir}")
  end
end

desc 'Compress'
task :compress => [:pkg, :tds] do
  Dir.chdir("dist/tds") do
    system('zip', '--recurse-paths', "../pkg/#{@name}.tds.zip", '.')
  end
  Dir.chdir("dist/pkg") do
    system('zip', '--recurse-paths', "../#{@name}.zip", '.')
  end
end

desc 'Build'
task :build => [:pkg, :tds, :compress]

def copy_with_path(mask, path)
  mkdir_p(path)
  cp_r(Dir[mask], path)
end

desc 'Prepare package'
task :ctanify do
  `ctanify --pkgname mypkg dummy.tex`
end

desc 'Upload'
task :ctanupload do
  # puts Open3.capture3(@meta['ctan'], 'ctanupload')
end

require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

Cucumber::Rake::Task.new(:report) do |t|
  t.cucumber_opts = "features --format html --out report.html"
end

require 'rake/clean'
CLEAN.include 'dist/pkg', 'dist/tds'
CLOBBER.include 'dist'

desc 'Install locally'
task :install => :tds do
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
