class Trip < ApplicationRecord
    has_many :userstrips
    has_many :users, through: :userstrips
end
