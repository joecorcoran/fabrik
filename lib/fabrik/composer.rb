require 'fabrik/conflict'

module Fabrik
  module Composer
    def compose(*method_maps)
      resolved_method_map = _resolve(method_maps)
      _compose!(resolved_method_map)
    end

    private

      def _resolve(method_maps)
        method_maps.reduce({}) do |result, method_map|
          result.merge!(method_map) do |name, m1, m2|
            m1 == m2 ? m1 : Conflict.instance_method(:raise_conflicting_method)
          end
        end
      end

      def _compose!(method_map)
        method_map.each do |name, method|
          unless self.instance_methods(false).include?(name)
            self.send(:define_method, name, method)
          end
        end
      end
  end
end
