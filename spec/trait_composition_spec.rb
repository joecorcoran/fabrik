require 'spec_helper'
require 'fabrik'

describe 'Trait composition' do

  specify %Q{
    A method defined in a composing trait takes precedence over a method
    provided by another trait
  } do
    t1 = Class.new { extend(Fabrik::Trait); provides { def a; 1 end } }
    t2 = Class.new do
      extend Fabrik::Trait
      provides { def a; 2 end }
      compose t1.trait!
    end
    klass = Class.new do
      extend Fabrik::Composer
      compose t2.trait!
    end

    expect(klass.new.a).to eq (2)
  end

  specify %Q{
    Methods can be excluded from traits by a composing trait to avoid conflicts
  } do
    t1 = Class.new { extend(Fabrik::Trait); provides { def a; 1 end } }
    t2 = Class.new { extend(Fabrik::Trait); provides { def a; 2 end } }
    t3 = Class.new do
      extend Fabrik::Trait
      compose t1.trait!, t2.trait!(exclude: :a)
    end
    klass = Class.new do
      extend Fabrik::Composer
      compose t3.trait!
    end

    expect(klass.new.a).to eq (1)
  end

  specify 'Methods can be aliased by a composing trait to avoid conflicts' do
    t1 = Class.new { extend(Fabrik::Trait); provides { def a; 1 end } }
    t2 = Class.new { extend(Fabrik::Trait); provides { def a; 2 end } }
    t3 = Class.new do
      extend Fabrik::Trait
      compose t1.trait!, t2.trait!(aliases: { a: :z })
    end
    klass = Class.new do
      extend Fabrik::Composer
      compose t3.trait!
    end

    expect(klass.new.a).to eq (1)
    expect(klass.new.z).to eq (2)
  end

  specify 'There is no conflict if two traits provide the same method' do
    m  = Module.new { def a; 1 end }
    t1 = Class.new  { extend(Fabrik::Trait); provides_from m, :a }
    t2 = Class.new  { extend(Fabrik::Trait); provides_from m, :a }
    t3 = Class.new do
      extend Fabrik::Trait
      compose t1.trait!, t2.trait!
    end
    klass = Class.new do
      extend Fabrik::Composer
      compose t3.trait!
    end

    expect(klass.new.a).to eq(1)
  end

end
