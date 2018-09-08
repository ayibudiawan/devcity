class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.integer :requestor_id
      t.integer :target_id
      t.boolean :is_friend, :default => false
      t.boolean :is_subscribe, :default => false
      t.boolean :is_block, :default => false
      t.timestamps
    end
  end
end
