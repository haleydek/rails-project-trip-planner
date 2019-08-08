class Trip < ApplicationRecord
    has_many :userstrips
    has_many :users, through: :userstrips

    validates :title, presence: true, uniqueness: { scope: :user_id }
end
