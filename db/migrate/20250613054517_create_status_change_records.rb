class CreateStatusChangeRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :status_change_records do |t|
      t.integer :action

      t.timestamps
    end
  end
end
