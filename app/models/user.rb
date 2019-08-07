class User < ApplicationRecord
    validates :name, presence: true
    validates :email, presence: true, uniqueness: { case_sensitive: false, message: "Sorry, this email is already associated with an account." }

    has_secure_password

    def self.find_or_create_from_auth_hash(auth)
        # find the first record with a matching uid and update it via #tap
        # OR if no matching record exists, create a new one.
        where(uid: auth.uid).first_or_initialize.tap do |user|
            user.uid = auth.uid
            user.name = auth.info.name
            user.email = auth.info.email
            user.image = auth.info.image
            user.password = SecureRandom.urlsafe_base64
            user.save!
        end
    end
    
end