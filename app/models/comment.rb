# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :project

  validates :user_name, :body, presence: true

  scope :persisted, -> { where.not(id: nil) }
end
