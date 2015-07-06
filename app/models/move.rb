class Move < ActiveRecord::Base
  extend DecoratorDelegateMethods

  belongs_to :user
  has_many :appearances, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :ratings, as: :rateable

  validates :name, presence: true, uniqueness: true

  use WithRatingStats, for: :average_rating
end
