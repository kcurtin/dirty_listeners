# DirtyListeners

Add lifecycle aware dirty attribute listeners to your project.

## Installation

Add this line to your application's Gemfile:

    gem 'dirty_listeners'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dirty_listeners

## Usage
```ruby

## Include the module in your ActiveRecord class
class Dog < ActiveRecord::Base
  include DirtyListener::Subscriptions
end

## Create a listener
class ExampleListener < DirtyListener::BaseListener
  listening_to :dog do
    order :age_change, :name_change

    on :name_change, unless: "old.nil?" do |old, new|
      # ...
    end

    on :age_change do |old, new|
      # ...
    end

    on :birthday_change do |old, new|
      # ...
    end

    on :awake_change do |old, new|
      # ...
    end
  end
end

## Add the listener to the object and specify the lifecycle event you want it to fire on
listener = ExampleListener.new
dog = Dog.new
dog.subscribe listener, to: :before_save
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/dirty_listeners/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
