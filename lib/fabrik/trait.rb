require 'fabrik/dictionary'

module Fabrik
  module Trait

    def trait!(opts = {})
      dictionary.method_map(opts)
    end

    def provides_from(mod, *names)
      names.each do |name|
        dictionary.add([mod, name])
      end
    end

    def dictionary
      @dictionary ||= Dictionary.new
    end
    
  end
end
