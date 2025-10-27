class Response < ApplicationRecord
  belongs_to :survey
  belongs_to :question
  
  validates :value, presence: true
  before_validation :normalize_role

  validates :role, presence: true

  private

  def normalize_role
    self.role = role.to_s.strip.downcase if role
  end
end
