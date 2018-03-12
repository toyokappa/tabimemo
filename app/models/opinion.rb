class Opinion
  include ActiveModel::Model

  attr_accessor :user, :email, :content
  validates_presence_of :content
end
