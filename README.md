# Apoapsis

Apoapsis is a framework to allow for writing fully supervised ruby code in a 
functional style.  It is not intended to be purely functional, only as
functional as it can be while still being ruby and being practical.

It provides heavyweight process coordination and lightweight thread
management alongside state management.  On second thought, it is probably
beneficial to only use lightweight process management as it won't thwart the
branch prediction, and I'd guess that the overhead of multiple processes would
not be worth the deterioration of performance.  I could be wrong though.

## Installation

Add this line to your application's Gemfile:

    gem 'Apoapsis'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install Apoapsis

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/Apoapsis/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
