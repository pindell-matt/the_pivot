class RemoveOrganizationFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :organization, :string
  end
end
