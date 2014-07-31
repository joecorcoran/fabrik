require 'fabrik/conflict'

module Fabrik
  class Resolver < Struct.new(:dicts)
    def dictionary!
      dicts.reduce({}) do |result, dict|
        result.merge!(dict) do |name, _, _|
          Conflict.instance_method(:raise_conflicting_method)
        end
      end
    end
  end
end
