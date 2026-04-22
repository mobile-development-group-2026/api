class User < ApplicationRecord
  has_one :student_profile, dependent: :destroy
  has_one :lifestyle_profile, dependent: :destroy
  has_one :listing_profile, dependent: :destroy
  has_one :landlord_profile, dependent: :destroy
  has_many :listings, dependent: :destroy
  has_many :student_applications, class_name: "Application", foreign_key: :student_id, dependent: :destroy

  validates :clerk_id, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, presence: true, inclusion: { in: %w[student landlord] }

  scope :students, -> { where(role: "student") }
  scope :landlords, -> { where(role: "landlord") }

  def student?
    role == "student"
  end

  def landlord?
    role == "landlord"
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
