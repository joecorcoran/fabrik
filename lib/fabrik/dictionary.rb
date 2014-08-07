module Fabrik
  class Dictionary

    def initialize
      @pairs = Set.new
    end

    def add(pair)
      @pairs.add(pair)
    end

    def methods(opts = {})
      exclude = Array(opts[:exclude])
      aliases = opts.fetch(:aliases, {})

      methods = Hash[
        @pairs.map do |pair|
          mod, name = pair
          [name, mod.instance_method(name)]
        end
      ]
      methods = apply_exclusions(methods, exclude)
      methods = apply_aliases(methods, aliases)
    end

    def apply_exclusions(methods, exclusions)
      methods.select do |name, _|
        !exclusions.include?(name)
      end
    end

    def apply_aliases(methods, aliases)
      Hash[
        methods.map do |name, _|
          [(aliases.include?(name) ? aliases[name] : name), _]
        end
      ]
    end

  end
end
