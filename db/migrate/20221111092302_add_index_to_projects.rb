class AddIndexToProjects < ActiveRecord::Migration[7.0]
  def change
    add_index :projects, :subdomain, unique: true
  end
end
