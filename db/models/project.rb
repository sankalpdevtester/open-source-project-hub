```ruby
# db/models/project.rb

class Project < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :reviews, dependent: :destroy
  has_many :discussions, dependent: :destroy
  has_many :project_showcases, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :description, presence: true, length: { minimum: 10, maximum: 500 }
  validates :url, presence: true, format: { with: /\Ahttps?:\/\/[^\s]+\z/ }
  validates :user_id, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :popular, -> { order(reviews_count: :desc) }

  # Callbacks
  before_save :set_default_values

  private

  def set_default_values
    self.reviews_count ||= 0
    self.discussions_count ||= 0
  end
end

class User < ApplicationRecord
  # Associations
  has_many :projects, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :discussions, dependent: :destroy

  # Validations
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :email, presence: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
  validates :password, presence: true, length: { minimum: 8, maximum: 128 }

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :active, -> { where(active: true) }
end

class Review < ApplicationRecord
  # Associations
  belongs_to :project
  belongs_to :user

  # Validations
  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :comment, presence: true, length: { minimum: 10, maximum: 500 }
end

class Discussion < ApplicationRecord
  # Associations
  belongs_to :project
  belongs_to :user

  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 50 }
  validates :content, presence: true, length: { minimum: 10, maximum: 500 }
end

class ProjectShowcase < ApplicationRecord
  # Associations
  belongs_to :project

  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 50 }
  validates :description, presence: true, length: { minimum: 10, maximum: 500 }
end
```