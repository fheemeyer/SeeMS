class ContentPage < Page
  field :content
  field :url

  belongs_to :parent, class_name: "NavigationPage", inverse_of: :children
end
