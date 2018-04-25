require 'erb'

module TeXWorld
  class Document
    def initialize(cfg)
      @content = cfg.fetch('content')
      @idioms  = cfg.fetch('idioms')
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

    def idiom_inside(binding)
      before = ERB.new(@idioms.fetch('enclose').fetch('before')).result(binding)
      after = ERB.new(@idioms.fetch('enclose').fetch('after')).result(binding)
      wrap_body(before, after)
    end

    def idiom_use(binding)
      macro = ERB.new(@idioms.fetch('use')).result(binding)
      append_to('preamble', macro)
    end

    def set_content(part, text)
      @content[part] = text
    end

    def sourcecode
      <<~TEXCODE
        #{@content['preamble'].strip}
        #{@content['head'].strip}
        #{@content['body'].strip}
        #{@content['tail'].strip}
      TEXCODE
    end
  end
end
