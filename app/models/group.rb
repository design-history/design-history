# == Schema Information
#
# Table name: projects
#
#  id               :bigint           not null, primary key
#  comments_enabled :boolean          default(FALSE)
#  description      :string
#  owner_type       :string           not null
#  password         :string
#  related_links    :text             default("")
#  subdomain        :string
#  theme            :string           default("dh"), not null
#  title            :string
#  type             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  owner_id         :bigint           not null
#  project_id       :bigint
#
# Indexes
#
#  index_projects_on_owner       (owner_type,owner_id)
#  index_projects_on_project_id  (project_id)
#  index_projects_on_subdomain   (subdomain) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
class Group < Project
  has_many :projects, foreign_key: :project_id
end
