class Page
  include Mongoid::Document

  field :title

  has_many :children, class_name: "Page", inverse_of: :parent
  belongs_to :parent, class_name: "Page", inverse_of: :children

  def full_url
    "/p/#{self.url}"
  end
end
