class AddProjectIdToProjects < ActiveRecord::Migration[7.1]
  def change
    add_reference :projects, :project, foreign_key: true
  end
end
