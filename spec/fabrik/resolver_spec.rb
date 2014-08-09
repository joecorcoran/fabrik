require 'spec_helper'
require 'fabrik/errors'
require 'fabrik/resolver'

describe Fabrik::Resolver do

  describe '#resolved_method_map' do
    it 'returns a hash with all keys merged' do
      resolver = Fabrik::Resolver.new([
        { a: double('UnboundMethod'), b: double('UnboundMethod') },
        { b: double('UnboundMethod') }
      ])
      expect(resolver.resolved_method_map.keys).to eq [:a, :b]
    end

    it 'constructs a conflict method if two methods have the same key' do
      m1, m2 = double('UnboundMethod'), double('UnboundMethod')
      resolver = Fabrik::Resolver.new([
        { a: m1 },
        { a: m2 }
      ])
      expect(resolver).to receive(:conflict_method).with(:a, m1, m2).once
      resolver.resolved_method_map
    end
  end

  describe '#conflict_method' do
    it 'returns an unbound method' do
      m1, m2 = double('UnboundMethod'), double('UnboundMethod')
      resolver = Fabrik::Resolver.new([])
      expect(resolver.conflict_method(:foo, m1, m2)).to be_an UnboundMethod
    end

    it 'returns a method that raises when called' do
      m1     = double('UnboundMethod', owner: :foo)
      m2     = double('UnboundMethod', owner: :bar)
      klass  = Class.new
      method = Fabrik::Resolver.new([]).conflict_method(:baz, m1, m2)

      expect { method.bind(klass.new).call }.to raise_error(
        Fabrik::ConflictingMethods
      )
    end
  end

end
