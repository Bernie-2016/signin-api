class User < ActiveRecord::Base
  has_many :events

  enum role: [:user, :admin]
end
