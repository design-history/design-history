class AddTypeToProject < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :type, :string
  end
end
