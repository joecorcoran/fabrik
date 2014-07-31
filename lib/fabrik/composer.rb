require 'fabrik/resolver'

module Fabrik
  module Composer
    def compose(*trait_opts)
      dicts = trait_opts.map do |opts|
        trait = opts.delete(:trait)
        trait.dictionary(opts)
      end
      compose!(Resolver.new(dicts).dictionary!)
    end

    def compose!(dict)
      dict.each do |name, method|
        self.send(:define_method, name, method)
      end
    end
  end
end
