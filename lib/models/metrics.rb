require 'mongoid'

class Metric
  include Mongoid::Document

  field :type, type: String
  field :subtype, type: String
  field :datetime, type: DateTime
  field :category, type: String
  field :value

end