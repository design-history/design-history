class AddOwnerToProjects < ActiveRecord::Migration[7.0]
  def change
    add_reference :projects, :owner, polymorphic: true
  end
end
