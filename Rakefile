require 'fileutils'
require 'open3'

@name = 'kodi'

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
  cp(Dir[mask], path)
end

desc 'Prepare package'
task :ctanify do
  `ctanify --pkgname mypkg dummy.tex`
end

desc 'Prepare TDS'
task :tds do
  copy_with_path("src/tikzlibrary#{@name}*", "dist/tds/tex/generic/#{@name}")
  copy_with_path("src/#{@name}.sty", "dist/tds/tex/latex/#{@name}")
  copy_with_path("src/#{@name}.*", "dist/tds/doc/generic/#{@name}")
end

desc 'Prepare PKG'
task :pkg do
  copy_with_path('src/*', "dist/pkg/#{@name}")
end

desc 'Compress'
task :compress do
  Dir.chdir("dist/tds") do
    system('zip', '--recurse-paths', "../pkg/#{@name}.tds.zip", '.')
  end
  Dir.chdir("dist/pkg") do
    system('zip', '--recurse-paths', "../#{@name}.zip", '.')
  end
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


require 'erb'

desc 'Build step'
task :build do
  @src = 'src'
  @dst = 'build'
  source_template = File.read("#{@src}/HEADER.erb")
  @contents = File.read("#{@src}/kodi.sty")
  renderer = ERB.new(source_template)
  puts renderer.result()
end
