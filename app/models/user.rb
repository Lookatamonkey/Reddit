# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
    validates :username, :password_digest, :session_token, presence: true, uniqueness: true
    validates :password, length: { minimum: 8, allow_nil: true }
    attr_reader :password
    after_initialize :ensure_session_token

    # inverse_of references the same assocation in memory and therefore saves memory
    has_many(
        :subs,
        primary_key: :id,
        foreign_key: :moderator_id,
        class_name: :Moderator,
        inverse_of:
        :moderator
    )

    has_many(
        :posts,
        primary_key: :id,
        foreign_key: :author_id,
        class_name: :Post,
        inverse_of: :authors
    )

    def self.find_user_by_credentials(username, password)
        user = User.find_by(username: username)
        user && BCrypt::Password.new(password_digest).is_password?(password) ? user : nil
    end

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
    end

    def self.generate_session_token
        SecureRandom::urlsafe_base64(16)
    end

    def ensure_session_token
        self.session_token ||= User.generate_session_token
    end

    def reset.session_token!
        self.session_token = User.generate_session_token
        self.save!
        self.session_token
    end
end
