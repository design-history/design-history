class MakePostSlugsUnique < ActiveRecord::Migration[7.0]
  def change
    add_index :posts, %i[project_id slug], unique: true
  end
end
