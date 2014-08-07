require 'fabrik/dictionary'

module Fabrik
  module Trait

    def trait!(opts = {})
      dictionary.method_map(opts)
    end

    def provides(&own_definition)
      own.module_eval(&own_definition)
      provides_from(own, *own.instance_methods)
    end

    def provides_from(mod, *names)
      names.each do |name|
        dictionary.add([mod, name])
      end
    end

    def own
      @own ||= Module.new
    end

    def dictionary
      @dictionary ||= Dictionary.new
    end
    
  end
end
