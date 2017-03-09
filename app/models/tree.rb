class Tree < ActiveRecord::Base
  belongs_to :user
  has_many :node, dependent: :destroy
  attr_accessor :file
end
