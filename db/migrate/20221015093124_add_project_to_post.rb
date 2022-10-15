class AddProjectToPost < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :project, null: false, foreign_key: true
  end
end
