require 'spec_helper'
require 'fabrik'

describe 'Class composition' do

  specify %Q{
    A method provided by a trait takes precedence over a method inherited
    from a parent class
  } do
    t = Class.new    { extend(Fabrik::Trait); provides { def a; 1 end } }
    x = Class.new    { def a; 2 end }
    y = Class.new(x) { extend(Fabrik::Composer); compose(t.trait!) }

    expect(y.new.a).to eq(1)
  end

  specify %Q{
    A method defined in a composing class takes precedence over a method
    provided by a trait
  } do
    t = Class.new { extend(Fabrik::Trait); provides { def a; 1 end } }
    klass = Class.new do
      extend Fabrik::Composer
      def a; 2 end
      compose t.trait!
    end

    expect(klass.new.a).to eq (2)
  end

  specify %Q{
    Methods can be excluded from traits by a composing class to avoid conflicts
  } do
    t1 = Class.new { extend(Fabrik::Trait); provides { def a; 1 end } }
    t2 = Class.new { extend(Fabrik::Trait); provides { def a; 2 end } }

    klass = Class.new do
      extend Fabrik::Composer
      compose t1.trait!(exclude: :a), t2.trait!
    end

    expect(klass.new.a).to eq(2)
  end

  specify 'Methods can be aliased by a composing class to avoid conflicts' do
    t1 = Class.new { extend(Fabrik::Trait); provides { def a; 1 end } }
    t2 = Class.new { extend(Fabrik::Trait); provides { def a; 2 end } }

    klass = Class.new do
      extend Fabrik::Composer
      compose t1.trait!, t2.trait!(aliases: { a: :z })
    end

    expect(klass.new.a).to eq(1)
    expect(klass.new.z).to eq(2)
  end

  specify 'There is no conflict if two traits provide the same method' do
    m  = Module.new { def a; 1 end }
    t1 = Class.new  { extend(Fabrik::Trait); provides_from m, :a }
    t2 = Class.new  { extend(Fabrik::Trait); provides_from m, :a }

    klass = Class.new do
      extend Fabrik::Composer
      compose t1.trait!, t2.trait!
    end

    expect(klass.new.a).to eq(1)
  end

end
