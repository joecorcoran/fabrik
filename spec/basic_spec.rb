require 'spec_helper'
require 'fabrik'

module ModuleA
  def a; :a end
end

module Module1
  def x; 1 end
  def y; w end
  def z; 2 end
end

Trait1 = Fabrik::Trait.new do
  provides ModuleA, :a
  provides Module1, :x, :y, :z
end

module Module2
  def w; 9 end
  def x; 3 end
  def y; 4 end
  def z; q + 1 end
end

Trait2 = Fabrik::Trait.new do
  provides ModuleA, :a
  provides Module2, :w, :x, :y, :z
end

class Parent
  def w; 0 end
end

class Child < Parent
  extend Fabrik::Composer

  def x
    1
  end

  compose({ trait: Trait1, aliases: { z: :q } },
          { trait: Trait2, exclude: :y })
end

describe Fabrik do
  let(:child) { Child.new }

  specify 'no conflict if two traits provide same exact method' do
    expect(child.a).to eq(:a)
  end

  specify 'trait method takes precedence over inherited method' do
    expect(child.w).to eq(9)
  end

  specify 'method defined in composing class takes precedence over trait methods' do
    expect(child.x).to eq(1)
  end

  specify 'methods can be excluded from traits to avoid conflict' do
    expect(child.y).to eq(9)
  end

  specify 'methods can be aliased to avoid conflict' do
    expect(child.z).to eq(3)
  end
end
