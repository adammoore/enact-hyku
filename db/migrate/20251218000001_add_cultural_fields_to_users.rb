# frozen_string_literal: true

# Add cultural profile fields to users table for TK label access control
class AddCulturalFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :gender, :string
    add_column :users, :cultural_affiliations, :text
    add_column :users, :initiated_member, :boolean, default: false
  end
end
