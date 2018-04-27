require 'cucumber/rake/task'
require 'erb'
require 'fileutils'
require 'open3'
require 'rake/clean'
require 'yaml'
require 'colorize'
require 'digest'

require 'github_api'
require 'io/console'

METADATA = YAML.load_file('metadata.yaml')
METADATA['today'] = Date.today.strftime('%Y/%m/%d')

def print_task_title(task)
  title = "#{task.name} | #{task.comment}"
  puts ("#==[ #{title} ]" + '=' * 80)[0, 80].light_green
end

# ################################################################################

# # desc 'Prepare package'
# # task :ctanify do
# #   `ctanify --pkgname mypkg dummy.tex`
# # end

# desc 'Upload'
# task :ctanupload do
#   # puts Open3.capture3(METADATA['ctan'], 'ctanupload')
# end

# ################################################################################

# #==[ features ]=================================================================

# task :features, :features_regexp, :tex_envs_regexp do |_task, args|
#   features_regexp = args[:features_regexp] || '.*'
#   tex_envs_regexp = args[:tex_envs_regexp] || '.*'

#   cucumber_options = [
#     '--format pretty',
#     '--no-source'
#   ]

#   tex_envs = YAML.safe_load File.read('features/support/texworld/cfg.yml')
#   tex_envs.select! { |k| k[/^#{tex_envs_regexp}$/] }
#   message = 'The provided TeX environment regexp has no matches.'
#   raise ArgumentError, message.red if tex_envs.empty?

#   features = Dir.glob('features/**/*.feature')
#   features.select! { |f| f[/#{features_regexp}/] }
#   message = 'The provided feature regexp has no matches.'
#   raise ArgumentError, message.red if features.empty?

#   filtered_features_tasks = []

#   generic_features = features.group_by { |f| f.include? 'generic' }

#   if generic_features.key? true
#     generic_features_filenames = generic_features[true].join ' '
#     tex_envs.each do |k, v|
#       hash = Digest::MD5.hexdigest(k + generic_features_filenames).to_sym
#       filtered_features_tasks <<= hash
#       Cucumber::Rake::Task.new(hash) do |task|
#         task.cucumber_opts = cucumber_options + [
#           "DIALECT=#{v['dialect']}",
#           "PIPELINE=#{v['pipeline']}"
#         ] + [generic_features_filenames]
#       end
#     end
#   end

#   if generic_features.key? false
#     non_generic_features_filenames = generic_features[false].join ' '
#     hash = Digest::MD5.hexdigest(non_generic_features_filenames).to_sym
#     filtered_features_tasks <<= hash
#     Cucumber::Rake::Task.new(hash) do |task|
#       task.cucumber_opts = cucumber_options + [non_generic_features_filenames]
#     end
#   end

#   unless filtered_features_tasks.empty?
#     task filtered_features: filtered_features_tasks
#     Rake::Task[:filtered_features].invoke
#   end
# end


# NOTE: need to print titles
Rake::TaskManager.record_task_metadata = true

CLEAN.include '**/build/'
CLOBBER.include '**/build/', '**/dist/'

desc "Install package in your personal tree"
task install: %i{dist:tds uninstall} do |task|
  print_task_title(task)
  basedir = `kpsewhich -var-value TEXMFHOME`.chomp
  cp_r 'dist/tds/.', basedir
end

desc "Uninstall package from your personal tree"
task :uninstall do |task|
  print_task_title(task)
  basedir = `kpsewhich -var-value TEXMFHOME`.chomp
  subdirs = METADATA['filemap'].keys
  subdirs.each { |subdir| rm_rf "#{basedir}/#{subdir}" }
end

namespace :build do
  desc "Build library into src/build/"
  task :src do |task|
    print_task_title(task)
    target_dir = 'src/build'
    mkdir_p(target_dir)
    cp_r(Dir['src/*.{tex,sty}'], target_dir)
    Dir["#{target_dir}/*.{tex,sty}"].each do |filename|
      source = File.read(filename)
      source.gsub!('<VERSION>', METADATA.fetch('version'))
      source.gsub!('<TODAY>', METADATA.fetch('today'))
      File.write(filename, source)
    end
  end

  desc "Build manual into doc/build/ (to skip pdf use SKIP_PDF=true)"
  task :doc do |task|
    print_task_title(task)
    target_dir = 'doc/build'
    mkdir_p target_dir

    cp_r(Dir['doc/README'], target_dir)

    print 'Flattening sourcecode... '
    # NOTE: this is suboptimal, given the bugs of latexpand, but... meh.
    cmd = ['latexpand', '--output=build/kodi-doc.tex', '--keep-comments', 'main.tex']
    _stdout, stderr, status = Open3.capture3(*cmd, chdir: 'doc')
    raise StandardError, stderr.red unless status.success?
    print "Done.\n"

    print 'Compiling... '
    if ENV['SKIP_PDF'] == 'true'
      puts "Skipped!"
    else
      Dir.chdir target_dir do
        _stdout, stderr, status = Open3.capture3('latexmk', '-gg', 'kodi-doc.tex')
        raise StandardError, stderr.red unless status.success?
        _stdout, stderr, status = Open3.capture3('dvips', 'kodi-doc.dvi')
        raise StandardError, stderr.red unless status.success?
        _stdout, stderr, status = Open3.capture3('ps2pdf', 'kodi-doc.ps')
        raise StandardError, stderr.red unless status.success?
      end
      puts "Done!"
    end
  end
end

namespace :dist do
  desc "Prepare flat package structure into dist/pkg/"
  task pkg: %i{dist:tds dist:tds_zip} do |task|
    print_task_title(task)
    source_dir = 'dist/tds'
    target_dir = 'dist/pkg/kodi'
    mkdir_p target_dir

    # NOTE: we're just flattening the TDS
    cp_r Dir["#{source_dir}/**/*"].select { |f| File.file?(f) }, target_dir
    cp_r 'dist/kodi.tds.zip', 'dist/pkg'
  end

  desc "Prepare tree package structure into dist/tds/"
  task tds: %i{build:src build:doc} do |task|
    print_task_title(task)
    target_dir = 'dist/tds'

    filemap = METADATA.fetch('filemap').map do |target_subdir, source_globs|
      [target_subdir, Dir[*source_globs.map { |f| ["src/build/#{f}", "doc/build/#{f}"] }.flatten]]
    end

    filemap.each do |target_subdir, source_globs|
      target_fulldir = "#{target_dir}/#{target_subdir}"
      mkdir_p target_fulldir
      cp_r source_globs, target_fulldir
    end

    print 'Prepending headers... '
    code_renderer = ERB.new(File.read('HEADER.erb'), 0, '-')
    Dir["#{target_dir}/**/*.{tex,sty}"].each do |filename|
      @filename = File.basename(filename)
      @source = File.read(filename)
      @filemap = filemap
      @meta = METADATA
      File.write(filename, code_renderer.result)
    end
    puts "Done!"
  end

  desc "Archive tree package structure into dist/kodi.tds.zip"
  task tds_zip: %i{dist:tds} do |task|
    print_task_title(task)
    Dir.chdir('dist/tds') do
      system('zip', '--recurse-paths', '../kodi.tds.zip', '.')
    end
  end

  desc "Archive flat package structure into dist/kodi.zip"
  task pkg_zip: %i{dist:pkg} do |task|
    print_task_title(task)
    Dir.chdir('dist/pkg') do
      system('zip', '--recurse-paths', '../kodi.zip', '.')
    end
  end

  desc "Prepare minimal koDi/standalone fmt into dist/kodi.fmt"
  task fmt: [:install] do |task|
    print_task_title(task)
    mkdir_p 'dist'
    cmd = ['pdftex', '-ini', '&latex kodi-livedemo.tex\dump', '--output-directory dist']
    _stdout, stderr, status = Open3.capture3(*cmd)
    raise StandardError, stderr.red unless status.success?
    rm('kodi-livedemo.log')
    mv('kodi-livedemo.fmt', 'dist/kodi.fmt')
  end
end

namespace :release do
  desc "Create release on Github"
  task github: %i{dist:pkg_zip} do |task|
    print_task_title(task)

    print "GH login: "
    login = STDIN.noecho(&:gets).chomp
    puts

    print "GH password: "
    password = STDIN.noecho(&:gets).chomp
    puts

    begin
      github = Github.new basic_auth: "#{login}:#{password}"

      version = METADATA.fetch('version')

      print "Creating release... "
      response = github.repos.releases.create(
        'paolobrasolin', 'kodi',
        tag_name: version,
        target_commitish: 'master',
        name: version,
        body: "Release of version #{version}",
        draft: false,
        prerelease: version.end_with?('.pre')
      )
      puts "done: #{response.body.html_url}"

      release_id = response.body.id

      print "Uploading assets... "
      response = github.repos.releases.assets.upload(
        'paolobrasolin', 'kodi', release_id, 'dist/kodi.zip',
        name: "kodi-#{version}.zip",
        content_type: "application/zip"
      )
      puts "done."
    rescue Github::Error::GithubError => error
      puts error.message.red
    end
  end
end
