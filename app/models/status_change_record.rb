# frozen_string_literal: true

class StatusChangeRecord < ApplicationRecord
  validates :action, presence: true

  belongs_to :project
end
