require 'open3'
require 'erb'

#
module TeXWorld
  #
  class Job
    attr_accessor :document
    attr_accessor :pipeline
    attr_accessor :jobname

    def jobname
      hash
    end

    def hash
      Digest::MD5.hexdigest(@document.content.to_yaml)
    end

    def initialize
      @document = TeXWorld::Document.new
      @pipeline = TeXWorld::Pipeline.new
    end

    def run
      @document.write(".tex-test/#{hash}.tex")
      @pipeline.run(binding)
    end
  end

  #
  class Document
    attr_accessor :dialect
    attr_accessor :idioms
    attr_accessor :content

    def initialize(
      dialect = 'latex',
      source = 'features/support/dialects.yaml'
    )
      @source = source
      load_dialect(dialect)
    end

    def load_dialect(dialect, source = @source)
      @content = YAML.load_file(source)[dialect]['content']
      @idioms = YAML.load_file(source)[dialect]['idioms']
    end

    def append_to_preamble(code)
      @content['preamble'] <<= code
    end

    def append_to_body(code)
      @content['body'] <<= code
    end

    def wrap_body(before, after)
      @content['head'].concat(before)
      @content['tail'].prepend(after)
    end

    def write(filename)
      File.open(filename, 'w') do |file|
        file.write <<TEXCODE
#{@content['preamble']}
#{@content['head']}
#{@content['body']}
#{@content['tail']}
TEXCODE
      end
    end
  end

  #
  class Pipeline
    attr_accessor :directives

    def initialize(
      pipeline = 'latex',
      source = 'features/support/pipelines.yaml'
    )
      @source = source
      load(pipeline)
    end

    def load(pipeline, source = @source)
      @directives = YAML.load_file(source)[pipeline]
    end

    def run(binding)
      instructions = @directives.map do |d|
        d.map! { |f| ERB.new(f).result(binding) }
      end
      instructions.map do |i|
        _stdout, _stderr, status = Open3.capture3(*i, chdir: '.tex-test')
        return false unless status.success?
      end
      true
    end
  end
end

World(TeXWorld)
