class UserResource < Avo::BaseResource
  self.title = :email
  self.includes = []
  # self.search_query = -> do
  #   scope.ransack(id_eq: params[:q], m: "or").result(distinct: false)
  # end

  field :id, as: :id
  # Fields generated from the model
  field :email, as: :text
  field :sign_in_count, as: :number
  field :current_sign_in_at, as: :date_time
  field :last_sign_in_at, as: :date_time
  field :current_sign_in_ip, as: :text
  field :last_sign_in_ip, as: :text
  field :team_id, as: :number
  field :admin, as: :boolean
  # field :team, as: :belongs_to
  # add fields here
end
