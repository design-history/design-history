class AddThemeToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :theme, :string, null: false, default: "dh"
  end
end
