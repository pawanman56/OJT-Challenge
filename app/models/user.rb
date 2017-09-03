class User < ApplicationRecord

  has_many :posts, dependent: :destroy
  has_many :comments

  attr_accessor :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 225},
                                    format: {with: VALID_EMAIL_REGEX},
                                    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, :password_confirmation, presence: true, length: {minimum: 6}

  class << self
    
    def new_token
      SecureRandom.urlsafe_base64
    end

    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
    
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailMailer.account_activation(self, self.activation_token).deliver_later
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest:   User.digest(reset_token), reset_sent_at:  Time.zone.now)
  end

  def send_password_reset_email
    UserMailMailer.password_reset(self, self.reset_token).deliver_later
  end

  def password_reset_exprired?
    reset_sent_at < 2.hours.ago
  end
  
  private

    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token = User.new_token
      #binding.pry
      self.activation_digest = User.digest(activation_token)
    end
end
