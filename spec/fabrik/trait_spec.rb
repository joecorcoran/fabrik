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

  describe '::build' do
    it 'allows to build a trait class' do
      trait_klass = Fabrik::Trait.build do
        def a; end
      end

      expect(trait_klass.own.instance_methods).to include(:a)
    end

    it 'allows to compose different traits' do
      trait_a = Fabrik::Trait.build do
        def a; :a end
        def c; :c end
      end

      trait_b = Fabrik::Trait.build do
        def a; :ab end
        def b; :bc end
      end

      trait_c = Fabrik::Trait.build do
        def b; :cd end
      end

      trait_klass = Fabrik::Trait.build(trait_c, trait_b[exclude: :b], trait_a[exclude: :a])
      klass = Class.new.extend(Fabrik::Composer)
      klass.compose(trait_klass)
      instance = klass.new

      expect([instance.a, instance.b, instance.c]).to eq([:ab, :cd, :c])
    end
  end

  describe '.methods' do
    it 'returns the method map from the dictionary' do
      opts = {}
      expect(trait_klass.dictionary).to receive(:method_map).with(opts)
      trait_klass.methods(opts)
    end

    it 'is aliased as .[]' do
      opts = {}
      expect(trait_klass.dictionary).to receive(:method_map).with(opts)
      trait_klass[opts]
    end

    it 'calls provides_from with instance method names from own module' do
      trait_klass.provides { def a; end }
      expect(trait_klass).to receive(:provides_from).with(trait_klass.own, :a)
      trait_klass.methods
    end
  end

  describe '.provides' do
    it 'evaluates block in context of own module' do
      trait_klass.provides { def a; end }
      expect(trait_klass.own.instance_methods).to include :a
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
