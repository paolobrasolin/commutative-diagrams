require 'cucumber/rake/task'
require 'erb'
require 'fileutils'
require 'open3'
require 'rake/clean'
require 'yaml'

# TODO: fix filelist in header
# TODO: doc pass here is optional (simpler to handle stuff on Travis like this)

@meta = YAML.load(File.read('metadata.yaml'))

def print_title(title)
  print ("\n#==[ #{title} ]" + '=' * 80)[0,80] + "\n"
end

#==[ doc: build documents ]=====================================================

desc 'build documents'
task :doc do
  print_title 'build documents'

  # Make build folder.
  mkdir_p 'doc/build'

  print 'Flattening main doc sourcecode... '
  _stdout, stderr, status = Open3.capture3(
    # TODO: this is suboptimal, given the bugs of latexpand. But... meh.
    'latexpand', '--output=build/kodi-doc.tex', '--keep-comments', 'main.tex',
    chdir: 'doc'
  )
  raise StandardError, stderr unless status.success?
  print "Done.\n"

  print 'Loading header template... '
  code_template = File.read('HEADER.erb')
  code_renderer = ERB.new(code_template, 0, '<>')
  print "Done.\n"

  Dir.chdir 'doc/build' do
    print 'Applying header template to main doc sourcecode... '
    @filename = 'kodi-doc.tex'
    @source = File.read(@filename)
    File.write(@filename, code_renderer.result)
    print "Done.\n"

    print 'Compiling main doc sourcecode to PDF... '
    _stdout, stderr, status = Open3.capture3(
      'latexmk', '-pdf', '-gg', 'kodi-doc.tex'
    )
    raise StandardError, stderr unless status.success?
    print "Done.\n"
  end
end

#==[ src: build sourcecode ]====================================================

desc 'build sourcecode'
task :src do
  print_title 'build sourcecode'
  mkdir_p 'src/build'

  print 'Loading header template... '
  code_template = File.read('HEADER.erb')
  code_renderer = ERB.new(code_template, 0, '<>')
  print "Done.\n"

  print 'Applying header template to sourcecode files... '
  Dir.chdir 'src' do
    Dir['*.{tex,sty}'].each do |filename|
      @filename = filename
      @source = File.read(@filename)
      File.write("build/#{@filename}", code_renderer.result)
    end
  end
  print "Done.\n"
end

#==[ pkg: prepare files for PKG distribution ]==================================

desc 'prepare files for PKG distribution'
task pkg: [:src] do
  print_title 'prepare files for PKG distribution'
  target_folder = 'dist/pkg/kodi'
  mkdir_p target_folder

  print "Moving built documentation files...\n"
  src_files = ['README.md', 'doc/build/kodi-doc.tex', 'doc/build/kodi-doc.pdf']
  cp_r(src_files, target_folder)
  print "Done.\n"

  print "Moving built sourcecode files...\n"
  src_files = Dir['src/build/*.{tex,sty}']
  cp_r(src_files, target_folder)
  print "Done.\n"
end

#==[ tds: prepare files for TDS distribution ]==================================

desc 'prepare files for TDS distribution'
task tds: [:pkg] do
  print_title 'prepare files for TDS distribution'
  source_dir = 'dist/pkg/kodi'

  print "Moving files...\n"
  @meta['filemap'].each do |source_file, target_subdir|
    target_dir = "dist/tds/#{target_subdir}"
    mkdir_p target_dir
    cp_r(Dir["#{source_dir}/#{source_file}"], target_dir)
  end
  print "Done.\n"
end

#==[ zip: prepare archives for distribution ]===================================

desc 'prepare archives for distribution'
task zip: [:pkg, :tds] do
  print_title 'prepare archives for distribution'

  print "Zipping TDS tree...\n"
  Dir.chdir('dist/tds') do
    system('zip', '--recurse-paths', "../pkg/kodi.tds.zip", '.')
  end
  print "Done.\n"

  print "Zipping PKG folder...\n"
  Dir.chdir('dist/pkg') do
    system('zip', '--recurse-paths', "../kodi.zip", '.')
  end
  print "Done.\n"
end

################################################################################

# desc 'Prepare package'
# task :ctanify do
#   `ctanify --pkgname mypkg dummy.tex`
# end

desc 'Upload'
task :ctanupload do
  # puts Open3.capture3(@meta['ctan'], 'ctanupload')
end

################################################################################

task :features, :features_regexp, :tex_envs_regexp do |_task, args|
  features_regexp = args[:features_regexp] || '.*'
  tex_envs_regexp = args[:tex_envs_regexp] || '.*'

  options = [
    '--format pretty',
    '--no-source'
  ]

  tex_envs = YAML.safe_load(File.read('features/support/workflows.yaml'))
  tex_envs.select! { |k| k[/^#{tex_envs_regexp}$/] }
  raise ArgumentError, "The provided TeX environment regexp has no matches." if tex_envs.empty?

  features = Dir.glob("features/**/*.feature")
  features.select! { |f| f[/#{features_regexp}/] }
  raise ArgumentError, "The provided feature regexp has no matches." if features.empty?

  filtered_features_syms = []

  features.each do |filename|
    if filename.include?('generic')
      tex_envs.each do |k, v|
        hash = Digest::MD5.hexdigest(k+filename).to_sym
        filtered_features_syms <<= hash
        Cucumber::Rake::Task.new(hash) do |task|
          task.cucumber_opts = options + [
            "DIALECT=#{v['dialect']}",
            "PIPELINE=#{v['pipeline']}"
          ] + [filename]
        end
      end
    else
      hash = Digest::MD5.hexdigest(filename).to_sym
      filtered_features_syms <<= hash
      Cucumber::Rake::Task.new(hash) do |task|
        task.cucumber_opts = options + [filename]
      end
    end
  end

  task :filtered_features => filtered_features_syms
  Rake::Task[:filtered_features].invoke
end

#==[ install ]==================================================================

desc 'install'
task :install do
  print_title 'install locally'

  print "Moving files from the built TDS...\n"
  basedir = `kpsexpand '$TEXMFHOME'`.chomp
  cp_r 'dist/tds/.', basedir
  print "Done.\n"
end

#==[ uninstall ]================================================================

desc 'uninstall'
task :uninstall do
  print_title 'uninstall'

  print "Removing files from the $TEXMFHOME...\n"
  basedir = `kpsexpand '$TEXMFHOME'`.chomp

  puts @meta['filemap'].values.uniq.each do |subfolder|
    rm_rf "#{basedir}/#{subfolder}"
  end
  print "Done.\n"
end

#==[ reinstall ]================================================================

desc 'reinstall'
task reinstall: [:uninstall, :install]

#==[ dump minimal koDi/standalone format ]======================================

desc 'dump minimal koDi/standalone format'
task format: :install do
  mkdir_p 'dist'
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

#==[ cleanup ]==================================================================

CLEAN.include '**/dist/'
CLOBBER.include '**/dist/', '**/build/'
