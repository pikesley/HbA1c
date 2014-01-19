require 'mongoid'

class Metric
  include Mongoid::Document

  field :name, type: String
  field :datetime, type: DateTime
  field :category, type: String
  field :value, type: Float
end