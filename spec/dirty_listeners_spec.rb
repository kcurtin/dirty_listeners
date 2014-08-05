require 'spec_helper'

class ExampleListener < DirtyListener::BaseListener
  listening_to :dog do
    order :age_change, :name_change, :birthday_change

    on :name_change, unless: "old.eql?('George')" do |old, new|
      ordered_changes << :name_change
      history[:name_change] = [old, new]
    end

    on :age_change do |old, new|
      ordered_changes << :age_change
      history[:age_change] = [old, new]
    end

    on :birthday_change do |old, new|
      ordered_changes << :birthday_change
      history[:birthday_change] = [old, new]
    end

    on :awake_change do |old, new|
      ordered_changes << :awake_change
      history[:awake_change] = [old, new]
    end
  end
end

describe DirtyListeners do
  let(:dog) { Dog.new }
  let(:listener) { ExampleListener.new }

  it "triggers attribute callbacks for the attributes that changed" do
    dog.subscribe listener, to: :before_save
    dog.attributes = { name: "George", age: 5 }
    dog.save!

    expect(dog.history[:name_change]).to eql [nil, "George"]
    expect(dog.history[:age_change]).to eql [nil, 5]
  end

  it "does not execute callbacks if the #run_condition is false" do
    expect(listener).to receive(:run_condition).and_return(false)
    dog.subscribe listener, to: :after_save
    dog.name = "George" && dog.save!

    expect(dog.history[:name_change]).to be_nil
  end

  context "when callback order is specified" do
    it "executes callbacks in the specified order, and then executes the rest" do
      dog.subscribe listener, to: :before_save
      dog.attributes = { awake: false, name: "George", age: 5, birthday: Time.now }
      dog.save!

      expect(dog.ordered_changes).to eql [:age_change, :name_change, :birthday_change, :awake_change]
    end
  end

  context "when the #unless option is specified" do
    it "ignores the callback if it evals to true" do
      dog.update_attribute(:name, "George")
      dog.subscribe listener, to: :before_save
      dog.name = "Pete" && dog.save!

      expect(dog.history[:name_change]).to be_nil
    end
  end
end
