class AddPasswordToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :password, :string
  end
end
