class AddCommentsEnabledToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :comments_enabled, :boolean, default: false
  end
end
