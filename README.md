# Fabrik

[![Build Status](https://travis-ci.org/joecorcoran/fabrik.svg?branch=master)](https://travis-ci.org/joecorcoran/fabrik)

Traits for Ruby 2, as described in [Traits: A Mechanism for
Fine-grained Reuse][paper] by Ducasse, Nierstrasz, Schärli, Wuyts and Black.

## Usage

A class becomes a trait when it extends `Fabrik::Trait`.

```ruby
class Tiger
  extend Fabrik::Trait
end
```

Traits provide methods within a `provides` block.

```ruby
class Panthera
  extend Fabrik::Trait

  provides do
    def roar; :roar! end
  end
end
```

```ruby
class Tiger
  extend Fabrik::Trait

  provides do
    def mother; :tigress end
    def father; :tiger end
  end
end
```

```ruby
class Lion
  extend Fabrik::Trait

  provides do
    def mother; :lioness end
    def father; :lion end
  end
end
```

A class uses traits by extending `Fabrik::Composer` and composing the traits.

```ruby
class Tigon
  extend Fabrik::Composer
  compose Panthera, Tiger, Lion
end
```

```ruby
tigon = Tigon.new
tigon.roar    # => :roar!
tigon.mother  # => raises ConflictingMethods error
```

Conflicting methods must be resolved, by exclusion or aliasing during
composition, or by overriding in the composing class.

```ruby
class Tigon
  extend Fabrik::Composer
  compose Panthera,
          Tiger[exclude: :mother],
          Lion[exclude: :father]
end
```

```ruby
tigon = Tigon.new
tigon.roar    # => :roar!
tigon.mother  # => :lioness
tigon.father  # => :tiger
```

View the specs for further examples, including composable traits and traits
that provide methods from shared modules.

## Credits

Built by [Joe Corcoran][me].

## License

MIT.

[paper]: http://scg.unibe.ch/archive/papers/Duca06bTOPLASTraits.pdf
[me]: https://corcoran.io
