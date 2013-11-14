class ContentPage
  include Mongoid::Document

  field :title
  field :content

  belongs_to :parent, class_name: "Page", inverse_of: :children
end
