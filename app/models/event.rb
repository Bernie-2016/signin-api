class Event < ActiveRecord::Base
  belongs_to :user
  has_many :questions
  has_many :signups

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  accepts_nested_attributes_for :questions, allow_destroy: true

  default_scope -> { order(created_at: :desc) }

  def signups_count
    signups.count
  end

  def as_json(options = {})
    super(options.reverse_merge(methods: %i(signups_count questions)))
  end

  class << self
    def default
      find_or_create_by(name: 'Default', slug: 'default')
    end
  end
end
