class Tree < ActiveRecord::Base
  belongs_to :user
  has_many :node
  attr_accessor :file
end
