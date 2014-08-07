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

  describe '.provides_from' do
    it 'stores pairs in dictionary' do
      expect(trait_klass.dictionary).to receive(:add).with([mod, :a]).once
      expect(trait_klass.dictionary).to receive(:add).with([mod, :b]).once
      trait_klass.provides_from(mod, :a, :b)
    end
  end

end
