# frozen_string_literal: true

class AddProjectIdToStatusChangeRecord < ActiveRecord::Migration[7.1]
  def change
    add_column :status_change_records, :project_id, :integer
  end
end
