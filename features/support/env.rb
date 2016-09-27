require 'open3'

#
module TeXWorld
  #
  class Document
    attr_accessor :dialect
    attr_accessor :preamble
    attr_accessor :body

    def initialize(dialect = 'latex')
      @dialect = dialect
      @preamble = {
        'tex' => '',
        'latex' => '\documentclass{article}',
        'context' => ''
      }[dialect]
      @body = 'Hello world.'
      @body_delimiters = {
        'tex' => {
          open: '',
          close: '\bye'
        },
        'latex' => {
          open: '\begin{document}',
          close: '\end{document}'
        },
        'context' => {
          open: '\starttext',
          close: '\stoptext'
        },
      }[dialect]
    end

    def append_to_preamble(code)
      @preamble <<= code
    end

    def append_to_body(code)
      @body <<= code
    end

    def write_to_file(path, filename)
      File.open("#{path}/#{filename}", 'w') do |file|
        file.write <<TEXCODE
#{@preamble}
#{@body_delimiters[:open]}
#{@body}
#{@body_delimiters[:close]}
TEXCODE
      end
    end
  end

  #
  class Compiler
    attr_accessor :compiler

    def initialize(compiler)
      @compiler = compiler
    end

    def compile(path, filename)
      _stdout, _stderr, status = Open3.capture3(
        compiler, filename, chdir: path
      )
      status.success?
    end
  end

  attr_accessor :document
  attr_accessor :engine
end

World(TeXWorld)
