require 'fabrik/composer'
require 'fabrik/dictionary'
require 'forwardable'

module Fabrik
  module Trait
    include Composer

    extend Forwardable
    def_delegators :own, :instance_methods, :send

    def methods(opts = {})
      provides_from(own, *own.instance_methods)
      dictionary.method_map(opts)
    end

    def provides(&own_definition)
      own.module_eval(&own_definition)
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
