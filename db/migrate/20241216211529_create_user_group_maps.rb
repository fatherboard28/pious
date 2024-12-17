class CreateUserGroupMaps < ActiveRecord::Migration[8.0]
  def change
    create_table :user_group_maps do |t|
      t.integer :userId
      t.integer :groupId

      t.timestamps
    end
  end
end
