require 'fabrik/resolver'

module Fabrik
  module Composer
    def compose(*dicts)
      compose!(Resolver.new(dicts).dictionary!)
    end

    def compose!(dict)
      dict.each do |name, method|
        unless self.instance_methods(false).include?(name)
          self.send(:define_method, name, method)
        end
      end
    end
  end
end
