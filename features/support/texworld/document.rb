module TeXWorld
  class Document
    attr_reader :idioms
    attr_accessor :content

    def load(name)
      template = YAML.load_file(
        File.expand_path('../templates.yaml', __FILE__)
      )[name]
      @content = template['content']
      @idioms  = template['idioms']
    end

    def append_to(part, stuff)
      @content[part].strip!
      @content[part].concat("\n" + stuff.strip)
    end

    def wrap_body(before, after)
      @content['head'].strip!
      @content['head'].concat("\n" + before.strip)
      @content['tail'].strip!
      @content['tail'].prepend(after.strip + "\n")
    end

    def write(filename)
      sourcecode = <<TEXCODE
#{@content['preamble'].strip}
#{@content['head'].strip}
#{@content['body'].strip}
#{@content['tail'].strip}
TEXCODE
      File.open(filename, 'w') do |file|
        file.write sourcecode
      end
    end
  end
end
