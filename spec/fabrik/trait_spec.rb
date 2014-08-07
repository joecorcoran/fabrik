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

  describe '.provides' do
    it 'evaluates block in context of own module' do
      trait_klass.provides { def a; end }
      expect(trait_klass.own.instance_methods).to include :a
    end

    it 'calls provides from with instance method names from own module' do
      expect(trait_klass).to receive(:provides_from).with(trait_klass.own, :a)
      trait_klass.provides { def a; end }
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
