class ContentPage < Page
  field :content

  belongs_to :parent, class_name: "NavigationPage", inverse_of: :children
end
