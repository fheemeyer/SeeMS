class Page
  include Mongoid::Document

  field :title
  has_many :children, class_name: "ContentPage", inverse_of: :parent
end
