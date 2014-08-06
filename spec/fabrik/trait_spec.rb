require 'spec_helper'
require 'fabrik/trait'

describe Fabrik::Trait do

  before(:all) do
    module M
      def a; end
      def b; end
    end
  end

  let(:trait) { Fabrik::Trait.new }

  describe '#provides' do
    it 'stores names in provided' do
      trait.provides(M, :a)
      expect(trait.provided.include?(:a))
    end

    it 'does not overwrite or duplicate names when used more than once' do
      trait.provides(M, :a)
      trait.provides(M, :a)
      expect(trait.provided.length).to eq(1)
    end
  end

  describe '#dictionary' do
    it 'returns hash mapping method names to unbound methods' do
      trait.provides(M, :a, :b)
      expect(trait.dictionary).to eq(
        a: M.instance_method(:a), b: M.instance_method(:b)
      )
    end

    it 'applies exclusions if opts includes :exclude' do
      trait.provides(M, :a, :b)
      expect(trait).to receive(:apply_exclusions)
                         .with(trait.dictionary, [:a])
                         .and_call_original
      expect(trait.dictionary(exclude: [:a])).to eq(b: M.instance_method(:b))
    end

    it 'applies exclusions if opts includes :exclude with singular value' do
      trait.provides(M, :a, :b)
      expect(trait).to receive(:apply_exclusions)
                         .with(trait.dictionary, [:a])
                         .and_call_original
      expect(trait.dictionary(exclude: :a)).to eq(b: M.instance_method(:b))
    end

    it 'applies aliases if opts includes :aliases' do
      trait.provides(M, :a, :b)
      expect(trait).to receive(:apply_aliases).with(trait.dictionary, a: :z)
      trait.dictionary(aliases: { a: :z })
    end
  end

  describe '#apply_exclusions' do
    it 'returns hash without the excluded keys' do
      expect(trait.apply_exclusions({a: 1, b: 2}, [:a])).to eq(b: 2)
    end
  end

  describe '#apply_aliases' do
    it 'returns hash with keys aliased' do
      expect(
        trait.apply_aliases({a: 1, b: 2}, {b: :z})
      ).to eq(a: 1, z: 2)
    end
  end

end
