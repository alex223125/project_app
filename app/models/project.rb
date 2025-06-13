class Project < ApplicationRecord

  validates :title, :status, presence: true

end
