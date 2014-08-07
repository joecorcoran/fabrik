require 'spec_helper'
require 'fabrik/dictionary'

describe Fabrik::Dictionary do

  let(:mod) do
    Module.new do
      def a; end
      def b; end
    end
  end

  let(:dictionary) { Fabrik::Dictionary.new }

  describe '.method_map' do
    before do
      dictionary.add([mod, :a])
      dictionary.add([mod, :b])
    end
    it 'returns hash mapping method names to unbound methods' do
      expect(dictionary.method_map).to eq(
        a: mod.instance_method(:a), b: mod.instance_method(:b)
      )
    end

    it 'applies exclusions if opts includes :exclude' do
      expect(dictionary).to receive(:apply_exclusions)
                         .with(dictionary.method_map, [:a])
                         .and_call_original
      expect(dictionary.method_map(exclude: [:a])).to eq(
        b: mod.instance_method(:b)
      )
    end

    it 'applies exclusions if opts includes :exclude with singular value' do
      expect(dictionary).to receive(:apply_exclusions)
                         .with(dictionary.method_map, [:a])
                         .and_call_original
      expect(dictionary.method_map(exclude: :a)).to eq(
        b: mod.instance_method(:b)
      )
    end

    it 'applies aliases if opts includes :aliases' do
      expect(dictionary).to receive(:apply_aliases).with(
        dictionary.method_map, a: :z
      )
      dictionary.method_map(aliases: { a: :z })
    end
  end

  describe '.apply_exclusions' do
    it 'returns hash without the excluded keys' do
      expect(dictionary.apply_exclusions({ a: 1, b: 2 }, [:a])).to eq(b: 2)
    end
  end

  describe '.apply_aliases' do
    it 'returns hash with keys aliased' do
      expect(
        dictionary.apply_aliases({ a: 1, b: 2 }, { b: :z })
      ).to eq(a: 1, z: 2)
    end
  end
end
