class AddThemeAndSubdomainToTeams < ActiveRecord::Migration[7.1]
  def change
    change_table :teams, bulk: true do |t|
      t.string :theme
      t.string :subdomain, index: { unique: true }
    end
  end
end
