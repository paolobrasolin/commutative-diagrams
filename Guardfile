def core_dependants_of(name)
  dependencies = {}
  Dir['src/tikzlibrarycommutative-diagrams.*.code.tex'].each do |filename|
    code = File.read filename
    sublibrary_name = filename[/commutative-diagrams\.(.*)\.code/, 1]
    usetikzlibrary = /\\usetikzlibrary[\[{]commutative-diagrams\.(\w+)[\]}]/
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

guard 'cucumber', cli: '--profile guard', all_on_start: false, notification: false do
  watch(%r{^features/.+\.feature$})
  watch(%r{^src/tikzlibrarycommutative-diagrams\.(.+)\.code\.tex$}) do |m|
    core_dependants_of(m[1]).
      map { |n| "features/generic/#{n}" }.
      select { |f| File.exist? f }
  end
end
