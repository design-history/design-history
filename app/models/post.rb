# == Schema Information
#
# Table name: posts
#
#  id                :bigint           not null, primary key
#  body              :text
#  ordered_image_ids :json
#  published         :boolean
#  published_at      :date
#  related_links     :text             default("")
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
  MAX_SLUG_LENGTH = 50

  belongs_to :project

  has_many_attached :images
  has_many :comments, as: :commentable, dependent: :destroy

  extend FriendlyId
  friendly_id :title, use: :slugged

  before_validation :sanitize_content, if: :body?

  validates :title, presence: true, length: { maximum: 255 }
  validates :slug,
            presence: true,
            length: {
              maximum: MAX_SLUG_LENGTH
            },
            format: {
              with: /\A[a-z0-9-]+\z/
            },
            uniqueness: {
              scope: :project
            }
  validates :published_at, presence: true, if: -> { published == true }
  before_validation :generate_slug_from_title, on: %i[create update]
  before_validation :set_published_at, on: %i[create update]

  def ordered_images
    images.sort_by do |image|
      ordered_image_ids.index(image.id) || (image.id * 100)
    end
  end

  def images_at_bottom
    ordered_images.select { |image| image.custom_metadata["show_at_bottom"] }
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

  def append_images=(imgs)
    images.attach(imgs)
  end

  def generate_preview_token
    adjective = Faker::Emotion.adjective
    noun = [
      Faker::Ancient.god,
      Faker::Ancient.primordial,
      Faker::Ancient.titan,
      Faker::Ancient.hero
    ].sample
    hex = SecureRandom.hex(3)

    [adjective, noun, hex].map(&:parameterize).join('-')
  end

  private

  def sanitize_content
    sections = body.split("```")
    sections.each_with_index do |section, index|
      next if index.odd?

      sections[index] = ActionController::Base.helpers.sanitize(section)
    end
    self.body = sections.join("```").gsub("&gt;", ">")

    self.related_links = ActionController::Base.helpers.sanitize(related_links)
  end

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

  def generate_slug_from_title
    self.slug = title.parameterize.slice(0, MAX_SLUG_LENGTH) if slug.blank? &&
      title.present?
  end

  def set_published_at
    self.published_at = Time.zone.today if published? && published_at.blank?
  end
end
