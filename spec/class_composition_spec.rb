require 'spec_helper'
require 'fabrik'

describe 'Class composition' do

  specify %Q{
    A method provided by a trait takes precedence over a method inherited
    from a parent class
  } do
    m      = Module.new        { def a; 1 end }
    t      = Class.new         { extend(Fabrik::Trait); provides_from(m, :a) }
    parent = Class.new         { def a; 2 end }
    child  = Class.new(parent) { extend(Fabrik::Composer); compose(t.trait!) }

    expect(child.new.a).to eq(1)
  end

  specify %Q{
    A method defined in a composing class takes precedence over a method
    provided by a trait
  } do
    m     = Module.new { def a; 1 end }
    t     = Class.new  { extend(Fabrik::Trait); provides_from(m, :a) }
    klass = Class.new do
      extend(Fabrik::Composer)
      def a; 2 end
      compose(t.trait!)
    end

    expect(klass.new.a).to eq (2)
  end

  specify %Q{
    Methods can be excluded from traits by a composing class to avoid conflicts
  } do
    m1    = Module.new { def a; 1 end }
    t1    = Class.new  { extend(Fabrik::Trait); provides_from m1, :a }

    m2    = Module.new { def a; 2 end }
    t2    = Class.new  { extend(Fabrik::Trait); provides_from m2, :a }

    klass = Class.new do
      extend(Fabrik::Composer)
      compose(t1.trait!(exclude: :a), t2.trait!)
    end

    expect(klass.new.a).to eq(2)
  end

  specify 'Methods can be aliased by a composing class to avoid conflicts' do
    m1    = Module.new { def a; 1 end }
    t1    = Class.new  { extend(Fabrik::Trait); provides_from m1, :a }

    m2    = Module.new { def a; 2 end }
    t2    = Class.new  { extend(Fabrik::Trait); provides_from m2, :a }

    klass = Class.new do
      extend(Fabrik::Composer)
      compose(t1.trait!, t2.trait!(aliases: { a: :z }))
    end

    expect(klass.new.a).to eq(1)
    expect(klass.new.z).to eq(2)
  end

  specify 'There is no conflict if two traits provide the same method' do
    m     = Module.new { def a; 1 end }
    t1    = Class.new  { extend(Fabrik::Trait); provides_from m, :a }
    t2    = Class.new  { extend(Fabrik::Trait); provides_from m, :a }

    klass = Class.new do
      extend(Fabrik::Composer)
      compose(t1.trait!, t2.trait!)
    end

    expect(klass.new.a).to eq(1)
  end

end
