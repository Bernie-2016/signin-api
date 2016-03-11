class Question < ActiveRecord::Base
  belongs_to :event

  before_save :convert_boolean!

  self.inheritance_column = nil

  validate :verify_type

  serialize :choices, Array

  protected

  def convert_boolean!
    value = true if value == 'true' && type == 'checkbox'
  end

  def verify_type
    errors.add(:type, 'Invalid question type') unless %w(checkbox text select gotv).include? type
  end
end
