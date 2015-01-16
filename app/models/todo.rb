class Todo < ActiveRecord::Base
  validates :title, :presence => true

  enum status: [:open, :complete]

end
