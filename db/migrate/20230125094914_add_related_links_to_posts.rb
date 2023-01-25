class AddRelatedLinksToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :related_links, :text
  end
end
