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

guard 'rake', task: 'install' do
  watch(%r{^src/tikzlibrarykodi..+.code.tex$})
  watch('kodi.tex')
  watch('kodi.sty')
  watch('t-kodi.tex')
end

guard 'cucumber', cli: '--profile guard', all_on_start: false, notification: false do
  watch(%r{^features/.+\.feature$})
  watch(%r{^src/tikzlibrarykodi\.(.+)\.code\.tex$}) do |m|
    core_dependants_of(m[1]).
      map { |n| "features/generic/#{n}" }.
      select { |f| File.exist? f }
  end
end

guard 'rake', task: 'build:doc' do
  watch(%r{^doc/(?!build/).+\.tex})
end
