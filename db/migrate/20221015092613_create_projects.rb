class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :title, nullable: false
      t.string :description, nullable: false

      t.timestamps
    end
  end
end
