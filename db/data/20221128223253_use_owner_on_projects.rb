class UseOwnerOnProjects < ActiveRecord::Migration[7.0]
  def up
    Project.all.find_each do |project|
      project.owner = project.user
      project.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
