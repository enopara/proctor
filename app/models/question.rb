class Question < ApplicationRecord
  belongs_to :survey
  has_many :responses, dependent: :destroy
  
  validates :content, presence: true
  validates :question_type, presence: true
  
  # Define question types
  QUESTION_TYPES = ['text', 'long_text', 'multiple_choice', 'checkbox', 'rating'].freeze
  
  # Ensure position is maintained within a survey
  acts_as_list scope: :survey
  
  # Serialize options as an array
  serialize :options, Array
  
  # Ensure options are present for question types that need them
  validate :validate_options_for_question_type
  
  validates :content, presence: true
  validates :question_type, presence: true

  validate :validate_options_for_question_type
  
  # -------------------------------------------------
  # Role-based visibility:
  # - visible_for_roles is a jsonb array column
  # - [] means global (everyone can see this question)
  # - ["nurse"] means only "nurse" role should see it
  # -------------------------------------------------
  scope :visible_for, ->(role) {
    if role.blank?
      # If we don't know the role, only return global questions
      where("visible_for_roles = '[]'::jsonb")
    else
      # Return global questions OR questions whose visible_for_roles contains this role
      where(
        "visible_for_roles = '[]'::jsonb OR visible_for_roles @> to_jsonb(ARRAY[?]::text[])",
        role.to_s.downcase
      )
    end
  }
  
  private
  
  def validate_options_for_question_type
    if ['multiple_choice', 'checkbox'].include?(question_type) && (options.nil? || options.empty?)
      errors.add(:options, "can't be blank for #{question_type} questions")
    end
  end
end
