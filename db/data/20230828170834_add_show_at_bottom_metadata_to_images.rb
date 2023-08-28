# frozen_string_literal: true

class AddShowAtBottomMetadataToImages < ActiveRecord::Migration[7.0]
  def up
    ActiveStorage::Blob.all.each do |blob|
      blob.custom_metadata.merge!({ show_at_bottom: "1" })
      blob.save!
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
