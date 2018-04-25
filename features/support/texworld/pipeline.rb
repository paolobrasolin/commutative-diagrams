require 'erb'
require 'open3'

module TeXWorld
  class Pipeline
    def initialize(cfg)
      @commands = cfg
    end

    def run(binding, chdir:)
      cmds = @commands.map do |command|
        command.map do |component|
          ERB.new(component).result(binding)
        end
      end

      cmds.each do |command|
        _stdout, _stderr, status = Open3.capture3(*command, chdir: chdir)
        return false unless status.success?
      end

      true
    end
  end
end
