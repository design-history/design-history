class AddUserForm
  include ActiveModel::Model

  attr_accessor :email, :team
  validates :email, presence: true
  validates :team, presence: true

  def save
    return false if invalid?

    user = User.find_by_email(email)

    unless user
      errors.add(:email, :not_found)
      return false
    end

    if user.team.present?
      errors.add(:email, :has_team)
      return false
    end

    user.update!(team:)

    true
  end
end
