require 'fileutils'
require 'open3'

@name = 'kodi'

require 'erb'

desc 'Prepare PKG'
task :pkg do
  mkdir_p 'dist/pkg/kodi'
  cp('src/README', 'dist/pkg/kodi/README')
  source_files = FileList['src/*.sty', 'src/*.tex']
  source_template = File.read('src/HEADER.erb')
  source_renderer = ERB.new(source_template)
  source_files.each do |filename|
    @source = File.read(filename)
    target_filename = "dist/pkg/kodi/#{File.basename(filename)}"
    puts "render #{filename} to #{target_filename}"
    File.write(target_filename, source_renderer.result)
  end
end

desc 'Prepare TDS'
task :tds => :pkg do
  copy_with_path("dist/pkg/kodi/tikzlibrary#{@name}*", "dist/tds/tex/generic/#{@name}")
  copy_with_path("dist/pkg/kodi/#{@name}.sty", "dist/tds/tex/latex/#{@name}")
  copy_with_path("dist/pkg/kodi/#{@name}.*", "dist/tds/doc/generic/#{@name}")
  copy_with_path("dist/pkg/kodi/t-#{@name}.tex", "dist/tds/tex/context/third/#{@name}")
  copy_with_path("dist/pkg/kodi/README.md", "dist/tds/doc/generic/#{@name}/README.md")
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

@ctan = {
  'CONTRIBUTION' => 'kodi',
  'VERSION' => 'v0.0.0',
  'NAME' => 'Paolo Brasolin',
  'EMAIL' => 'paolo.brasolin@gmail.com',
  'SUMMARY' => '--',
  'DIRECTORY' => '/macros/generic/contrib/kodi',
  'DONOTANNOUNCE' => '',
  'ANNOUNCE' => '',
  'NOTES' => '',
  'LICENSE' => 'free',
  'FREEVERSION' => '',
  'FILE' => ''
}

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
  puts Open3.capture3(@ctan, 'ctanupload')
end

require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
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
  rm_rf "#{basedir}/doc/generic/kodi"
  rm_rf "#{basedir}/tex/generic/kodi"
  rm_rf "#{basedir}/tex/latex/kodi"
  rm_rf "#{basedir}/tex/context/third"
end
