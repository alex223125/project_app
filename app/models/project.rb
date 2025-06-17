# frozen_string_literal: true

class Project < ApplicationRecord
  validates :title, :status, :description, presence: true

  has_many :status_change_records, dependent: :destroy
  has_many :comments, dependent: :destroy
end
