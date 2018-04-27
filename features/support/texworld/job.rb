require 'digest'

require_relative 'document'
require_relative 'pipeline'

module TeXWorld
  FLAVOURS = YAML.load_file(
    File.expand_path('../../flavours.yml', __FILE__)
  )

  class Job
    attr_accessor :document
    attr_accessor :pipeline
    attr_accessor :path

    def load(flavour)
      cfg = Marshal.load(Marshal.dump(FLAVOURS.fetch(flavour)))
      @document = TeXWorld::Document.new(cfg.fetch('template'))
      @pipeline = TeXWorld::Pipeline.new(cfg.fetch('pipeline'))
    end

    def jobname
      path.basename.sub_ext('').to_s
    end

    def run
      path.write(@document.sourcecode)
      @pipeline.run(binding, chdir: path.dirname.to_s)
    end
  end
end
