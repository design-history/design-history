class SetOwnerNotNullOnProjects < ActiveRecord::Migration[7.0]
  def change
    change_column_null :projects, :owner_id, false
    change_column_null :projects, :owner_type, false
  end
end
