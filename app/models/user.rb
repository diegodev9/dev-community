class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :trackable,
         authentication_keys: [ :login ] # for authentication with username or email

  has_many :work_experiences, dependent: :destroy
  has_many :connections, dependent: :destroy

  after_commit :generate_slug

  validates :first_name, :last_name, :profile_title, presence: true
  validates :username, presence: true, uniqueness: true

  PROFILE_TITLE = [
    "Senior Ruby on Rails Developer",
    "Full Stack Ruby on Rails Developer",
    "Senior Full Stack Ruby on Rails Developer",
    "Junior Full Stack Ruby on Rails Developer",
    "Senior Java Developer",
    "Senior Front End Developer"
  ].freeze

  attr_writer :login # for login with username or email

  # for login with username or email
  def login
    @login || username || email
  end

  # for login with username or email
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where([ "lower(username) = :value OR lower(email) = :value", { value: login.downcase } ]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def to_param
    return nil unless persisted?
    slug
  end

  def address
    return nil if city.blank? && state.blank? && country.blank? && pincode.blank?

    "#{city}, #{state}, #{country}, #{pincode}"
  end

  def my_connection(user)
    Connection.where("(user_id = ? AND connected_user_id = ?) OR (user_id = ? AND connected_user_id = ?)", user.id, id, id, user.id)
  end

  def check_if_already_connected?(user)
    self != user && !my_connection(user).present?
  end

  def mutually_connected_ids(user)
    self.connected_user_ids.intersection(user.connected_user_ids)
  end

  private

  def generate_slug
    slug = [ id, first_name, last_name ].join("-")
    return if self.slug == slug
    self.update(slug:)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[city country]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
