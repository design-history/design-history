class ProjectResource < Avo::BaseResource
  self.title = :title
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  # Fields generated from the model
  field :title, as: :text
  # field :description, as: :textarea
  field :subdomain, as: :text
  # field :password, as: :password
  field :owner_type, as: :text
  field :owner_id, as: :number
  field :theme, as: :text
  # field :related_links, as: :textarea
  # field :owner, as: :belongs_to
  # field :posts, as: :has_many
  # add fields here
end
