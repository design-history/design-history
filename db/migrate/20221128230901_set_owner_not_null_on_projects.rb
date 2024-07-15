class SetOwnerNotNullOnProjects < ActiveRecord::Migration[7.0]
  def up
    change_table :projects, bulk: true do |t|
      t.change :owner_id, :bigint, null: false
      t.change :owner_type, :string, null: false
    end
  end

  def down
    change_table :projects, bulk: true do |t|
      t.change :owner_id, :bigint, null: true
      t.change :owner_type, :string, null: true
    end
  end
end
