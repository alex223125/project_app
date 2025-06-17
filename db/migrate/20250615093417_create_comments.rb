# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.string :user_name
      t.text :body
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
