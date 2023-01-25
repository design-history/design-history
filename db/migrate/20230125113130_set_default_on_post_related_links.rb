class SetDefaultOnPostRelatedLinks < ActiveRecord::Migration[7.0]
  def change
    change_column_default :posts, :related_links, from: nil, to: ""
  end
end
