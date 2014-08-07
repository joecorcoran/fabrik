require 'spec_helper'
require 'fabrik/trait'

describe Fabrik::Trait do

  before(:all) do
    module M
      def a; end
      def b; end
    end
  end

  let(:trait_klass) do
    Class.new.extend(Fabrik::Trait)
  end

  describe '.provides_from' do
    it 'stores names in provided' do
      trait_klass.provides_from(M, :a)

      expect(trait_klass.provided.include?(:a))
    end

    it 'does not overwrite or duplicate names when used more than once' do
      trait_klass.provides_from(M, :a)
      trait_klass.provides_from(M, :a)

      expect(trait_klass.provided.length).to eq(1)
    end
  end

  describe '.dictionary' do
    it 'returns hash mapping method names to unbound methods' do
      trait_klass.provides_from(M, :a, :b)

      expect(trait_klass.dictionary).to eq(
        a: M.instance_method(:a), b: M.instance_method(:b)
      )
    end

    it 'applies exclusions if opts includes :exclude' do
      trait_klass.provides_from(M, :a, :b)

      expect(trait_klass).to receive(:apply_exclusions)
                         .with(trait_klass.dictionary, [:a])
                         .and_call_original
      expect(trait_klass.dictionary(exclude: [:a])).to eq(
        b: M.instance_method(:b)
      )
    end

    it 'applies exclusions if opts includes :exclude with singular value' do
      trait_klass.provides_from(M, :a, :b)

      expect(trait_klass).to receive(:apply_exclusions)
                         .with(trait_klass.dictionary, [:a])
                         .and_call_original
      expect(trait_klass.dictionary(exclude: :a)).to eq(
        b: M.instance_method(:b)
      )
    end

    it 'applies aliases if opts includes :aliases' do
      trait_klass.provides_from(M, :a, :b)

      expect(trait_klass).to receive(:apply_aliases).with(
        trait_klass.dictionary, a: :z
      )
      trait_klass.dictionary(aliases: { a: :z })
    end
  end

  describe '#apply_exclusions' do
    it 'returns hash without the excluded keys' do
      expect(trait_klass.apply_exclusions({a: 1, b: 2}, [:a])).to eq(b: 2)
    end
  end

  describe '#apply_aliases' do
    it 'returns hash with keys aliased' do
      expect(
        trait_klass.apply_aliases({a: 1, b: 2}, {b: :z})
      ).to eq(a: 1, z: 2)
    end
  end

end
