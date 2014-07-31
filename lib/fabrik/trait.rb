module Fabrik
  class Trait
    attr_reader :provided

    def initialize(mod, &definition)
      @mod, @provided = mod, Set.new
      self.instance_eval(&definition) if definition
    end

    def provides(*names)
      @provided.merge(names)
    end

    def dictionary(opts = {})
      dict = Hash[
        @provided.map do |name|
          [name, @mod.instance_method(name)]
        end
      ]
      dict = apply_exclusions(dict, Array(opts[:exclude])) if opts[:exclude]
      dict = apply_aliases(dict, opts[:aliases]) if opts[:aliases]
      dict
    end

    def apply_exclusions(dict, exclusions)
      dict.select do |name, _|
        !exclusions.include?(name)
      end
    end

    def apply_aliases(dict, aliases)
      Hash[
        dict.map do |name, _|
          [(aliases.include?(name) ? aliases[name] : name), _]
        end
      ]
    end
  end
end
