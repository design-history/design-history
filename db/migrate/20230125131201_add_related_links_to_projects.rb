class AddRelatedLinksToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :related_links, :text, default: ""
  end
end
