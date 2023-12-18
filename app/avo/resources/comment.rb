class Avo::Resources::Comment < Avo::BaseResource
  self.title = :id
  self.includes = []
  # self.search_query = -> do
  #   query.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  def fields
    field :id, as: :id
    # Fields generated from the model
    field :body, as: :textarea
    field :email, as: :text
    field :name, as: :text
    field :spam, as: :boolean
    # add fields here
  end
end
