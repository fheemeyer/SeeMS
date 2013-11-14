class Application
  include Mongoid::Document

  attr_accessible :title

  field :title
  has_many :pages
end
