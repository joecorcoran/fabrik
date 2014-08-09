require 'fabrik/errors'

module Fabrik
  class Resolver
    attr_reader :conflicts

    def initialize(method_maps)
      @method_maps = method_maps
      @conflicts   = {}
    end

    def resolved_method_map
      @method_maps.reduce({}) do |result, method_map|
        result.merge!(method_map) do |name, m1, m2|
          m1 == m2 ? m1 : conflict_method(name, m1, m2)
        end
      end
    end

    def conflict_method(name, m1, m2)
      resolver, @conflicts[name] = self, [m1, m2]
      mod = Module.new do
        send(:define_method, name) do
          m1, m2 = resolver.conflicts[name]
          raise ConflictingMethods.new(
            "#{m1.owner} and #{m2.owner} both provide methods named :#{name}"
          )
        end
      end
      mod.instance_method(name)
    end

  end
end
