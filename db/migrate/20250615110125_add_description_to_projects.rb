# frozen_string_literal: true

class AddDescriptionToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :description, :text
  end
end
