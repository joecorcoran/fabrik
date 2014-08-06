require 'fabrik/conflict'

module Fabrik
  class Resolver < Struct.new(:dicts)
    def dictionary!
      dicts.reduce({}) do |result, dict|
        result.merge!(dict) do |name, m1, m2|
          m1 == m2 ? m1 : Conflict.instance_method(:raise_conflicting_method)
        end
      end
    end
  end
end
