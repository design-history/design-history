# == Schema Information
#
# Table name: posts
#
#  id                :bigint           not null, primary key
#  body              :text
#  ordered_image_ids :json
#  published         :boolean
#  published_at      :date
#  slug              :string
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  project_id        :bigint           not null
#
# Indexes
#
#  index_posts_on_project_id           (project_id)
#  index_posts_on_project_id_and_slug  (project_id,slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
class Post < ApplicationRecord
  has_many_attached :images

  extend FriendlyId
  friendly_id :title, use: :slugged

  validates :title, presence: true, length: { maximum: 255 }
  validates :slug, presence: true, length: { maximum: 50 }
  validates :body, presence: true
  validates :published_at, presence: true, if: -> { published == true }

  def ordered_images
    images.sort_by do |image|
      ordered_image_ids.index(image.id) || (image.id * 100)
    end
  end

  def ordered_image_ids=(ids)
    super(ids.map(&:to_i))
  end

  def ordered_image_move_up!(image)
    ordered_image_move!(image, :up)
  end

  def ordered_image_move_down!(image)
    ordered_image_move!(image, :down)
  end

  def first_image?(image)
    ordered_images.index(image).zero?
  end

  def last_image?(image)
    ordered_images.index(image) == ordered_images.size - 1
  end

  private

  def ordered_image_move!(image, where)
    unless image.is_a?(ActiveStorage::Attachment)
      raise TypeError "#{image} must be ActiveStorage::Attachment"
    end

    images = ordered_images.dup

    case where
    when :up
      ArrayElementMove.up!(images, image)
    when :down
      ArrayElementMove.down!(images, image)
    else
      raise "Unknown option #{where}"
    end

    self.ordered_image_ids = images.map(&:id)
    save!
    reload

    true
  end
end
