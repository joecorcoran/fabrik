require 'fabrik/resolver'

module Fabrik
  module Composer

    def compose(*method_maps)
      resolved_method_map = Resolver.new(method_maps).resolved_method_map
      resolved_method_map.each do |name, method|
        unless self.instance_methods(false).include?(name)
          self.send(:define_method, name, method)
        end
      end
    end

  end
end
