require 'open3'
require 'erb'

module TeXWorld
  class Pipeline
    def load(name)
      @directives = YAML.load_file(
        File.expand_path('../pipelines.yaml', __FILE__)
      )[name]
    end

    def run(binding)
      commandlines = @directives.map do |d|
        d.map! { |f| ERB.new(f).result(binding) }
      end
      commandlines.map do |commandline|
        _stdout, _stderr, status = Open3.capture3(*commandline, chdir: '.tex-test')
        return false unless status.success?
      end
      true
    end
  end
end
