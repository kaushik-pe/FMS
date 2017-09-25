class User < ApplicationRecord
  has_many :booking, :dependent => :delete_all
end
