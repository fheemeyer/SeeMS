class ContentPage < Page
  field :content, default: "Lorem Ipsum Dolor Sit Amet"
  field :url

  belongs_to :parent, class_name: "NavigationPage", inverse_of: :children
end
