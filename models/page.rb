class Page
  include Mongoid::Document

  field :title

  belongs_to :application
end
