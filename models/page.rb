class Page
  include Mongoid::Document

  field :title
  # For navigation
  field :score, type: Integer, default: 0

  has_many :children, class_name: "Page", inverse_of: :parent, autosave: true
  belongs_to :parent, class_name: "Page", inverse_of: :children

  def full_url
    "/p/#{self.url}"
  end

  def add_child(page)
    page.score = self.children.count
    page.save!
  end

  def update_children(child_ids)
    new_children = child_ids.map{|id| Page.find(id)}
    self.child_ids = child_ids
    self.save!
    new_children.each_with_index do |child, i|
      child.update_attribute(:score, i)
    end
  end

  def children_sorted
    self.children.order_by [:score, :asc]
  end
end
