require 'cucumber/rake/task'
require 'erb'
require 'fileutils'
require 'open3'
require 'yaml'


@name = 'kodi'

@meta = YAML.load(File.read('metadata.yaml'))

# TODO: fix filelist in header
desc 'prepare docs'
task :doc do
  # Make dist folder.
  mkdir_p 'doc/build'
  # Flatten TeX sourcecode.
  # TODO: this is suboptimal, given the bugs of latexpand. But... meh.
  _stdout, stderr, status = Open3.capture3(
    'latexpand',
    '--output=build/kodi-doc.tex',
    '--keep-comments',
    'main.tex',
    chdir: 'doc'
  )
  raise StandardError, stderr unless status.success?
  code_template = File.read('HEADER.erb')
  code_renderer = ERB.new(code_template, 0, '<>')
  Dir.chdir 'doc/build' do
    @filename = 'kodi-doc.tex'
    @source = File.read(@filename)
    # Prepend header to sourcecode.
    File.write(@filename, code_renderer.result)
    # Compile to PDF.
    _stdout, stderr, status = Open3.capture3(
      'latexmk', '-pdf', '-gg', 'kodi-doc.tex'
    )
    raise StandardError, stderr unless status.success?
  end
end

# TODO: fix filelist in header
desc 'prepare source'
task :src do
  code_template = File.read('HEADER.erb')
  code_renderer = ERB.new(code_template, 0, '<>')
  Dir.chdir 'src' do
    mkdir_p 'build'
    Dir["*.{tex,sty}"].each do |filename|
      @filename = filename
      @source = File.read(@filename)
      File.write("build/#{@filename}", code_renderer.result)
    end
  end
end

desc 'prepare PKG distribution'
task pkg: [:src, :doc] do
  target_folder = 'dist/pkg/kodi'
  # Make target folder.
  mkdir_p target_folder
  # Move prepared documentation files.
  cp('README.md', "#{target_folder}/README.md")
  cp('doc/build/kodi-doc.tex', "#{target_folder}/kodi-doc.tex")
  cp('doc/build/kodi-doc.pdf', "#{target_folder}/kodi-doc.pdf")
  # Move prepared sourcecode files.
  src_files = Dir['src/build/*.{tex,sty}']
  src_files.each do |source_filename|
    target_filename = "#{target_folder}/#{File.basename(source_filename)}"
    cp(source_filename, target_filename)
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
    source_dir = 'dist/pkg/kodi'
    target_dir = "dist/tds/#{target_subdir}"
    mkdir_p target_dir
    cp_r(Dir["#{source_dir}/#{source_file}"], target_dir)
  end
end

desc 'Compress'
task zip: [:pkg, :tds] do
  Dir.chdir('dist/tds') do
    system('zip', '--recurse-paths', "../pkg/#{@name}.tds.zip", '.')
  end
  Dir.chdir('dist/pkg') do
    system('zip', '--recurse-paths', "../#{@name}.zip", '.')
  end
end

desc 'Build'
task build: [:pkg, :tds, :compress]

# desc 'Prepare package'
# task :ctanify do
#   `ctanify --pkgname mypkg dummy.tex`
# end

desc 'Upload'
task :ctanupload do
  # puts Open3.capture3(@meta['ctan'], 'ctanupload')
end

task :features, :features_regexp, :tex_envs_regexp do |_task, args|
  features_regexp = args[:features_regexp] || '.*'
  tex_envs_regexp = args[:tex_envs_regexp] || '.*'

  options = [
    # '--dry-run',
    # '--format progress',
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
