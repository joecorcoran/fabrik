require 'spec_helper'
require 'fabrik/trait'

describe Fabrik::Trait do

  let(:mod) do
    Module.new do
      def a; end
      def b; end
    end
  end

  let(:trait_klass) do
    Class.new.extend(Fabrik::Trait)
  end

  describe '.trait!' do
    it 'returns the method map from the dictionary' do
      opts = {}
      expect(trait_klass.dictionary).to receive(:method_map).with(opts)
      trait_klass.trait!(opts)
    end
  end

  describe '.provides_from' do
    it 'stores pairs in dictionary' do
      expect(trait_klass.dictionary).to receive(:add).with([mod, :a]).once
      expect(trait_klass.dictionary).to receive(:add).with([mod, :b]).once
      trait_klass.provides_from(mod, :a, :b)
    end
  end

end
