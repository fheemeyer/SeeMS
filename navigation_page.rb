class NavigationPage < Page
  has_many :children, class_name: "ContentPage", inverse_of: :parent
end
