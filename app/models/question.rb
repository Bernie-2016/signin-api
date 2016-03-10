class Question < ActiveRecord::Base
  belongs_to :event

  self.inheritance_column = nil

  validate :verify_type

  protected

  def verify_type
    errors.add(:type, 'Invalid question type') unless %w(checkbox text gotv).include? type
  end
end
