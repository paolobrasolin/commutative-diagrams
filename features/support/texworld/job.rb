module TeXWorld
  class Job
    attr_accessor :document
    attr_accessor :pipeline

    def initialize
      @document = TeXWorld::Document.new
      @pipeline = TeXWorld::Pipeline.new
    end

    def jobname
      Digest::MD5.hexdigest(@document.content.to_s)
    end

    def run
      @document.write(".tex-test/#{jobname}.tex")
      @pipeline.run(binding)
    end
  end
end
