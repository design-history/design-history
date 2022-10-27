class AddSubdomainToProject < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :subdomain, :string, unique: true
  end
end
