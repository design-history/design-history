class AddOrderedImageIdsToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :ordered_image_ids, :json, default: []
  end
end
