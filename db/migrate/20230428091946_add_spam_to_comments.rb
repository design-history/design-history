class AddSpamToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :spam, :boolean, default: false
  end
end
