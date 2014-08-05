$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'dirty_listeners'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :dogs, force: true do |t|
    t.string   :name
    t.integer  :age
    t.datetime :birthday
    t.boolean  :awake
    t.timestamps
  end

  create_table :bones, force: true do |t|
    t.integer  :dog_id
    t.string   :flavor
    t.boolean  :eaten
    t.timestamps
  end
end

class Bone < ActiveRecord::Base
  belongs_to :dog
end

class Dog < ActiveRecord::Base
  include DirtyListener::Subscriptions

  has_many :bones

  accepts_nested_attributes_for :bones

  attr_accessor :history

  def history
    @history ||= {}
  end

  def ordered_changes
    @ordered_changes ||= []
  end
end
