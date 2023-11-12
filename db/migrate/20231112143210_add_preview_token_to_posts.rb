class AddPreviewTokenToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :preview_token, :string
  end
end
