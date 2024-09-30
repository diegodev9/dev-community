class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  after_commit :generate_slug

  PROFILE_TITLE = [
    "Senior Ruby on Rails Developer",
    "Full Stack Ruby on Rails Developer",
    "Senior Full Stack Ruby on Rails Developer",
    "Junior Full Stack Ruby on Rails Developer",
    "Senior Java Developer",
    "Senior Front End Developer"
  ].freeze

  def name
    "#{first_name} #{last_name}".strip
  end

  def to_param
    return nil unless persisted?
    slug
  end

  def address
    "#{city}, #{state}, #{country}, #{pincode}"
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
