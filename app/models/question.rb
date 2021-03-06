class Question < ApplicationRecord
  belongs_to :user, counter_cache: true
  has_many :tags
  has_many :answers
  has_many :question_invitations
  has_many :invitated_users, through: :question_invitations, source: :user
  has_many :bills
  has_many :question_likes
  has_many :liking_users, through: :question_likes, source: :user

  validates :title, presence: true
  validates :description, presence: true
  validates :tag_list, presence: true
  validates :downpayment, presence: true, numericality: { greater_than: 0 }

  # status 字段 有两种状态 open closed

  scope :published, -> { where(is_hidden: false) }
  scope :recent, -> { order("id DESC") }
  scope :opening, -> { where(status: "open") }
  acts_as_taggable_on :tags

  def updated_at_formate
    updated_at.strftime("%Y-%m-%d %H:%M:%S")
  end

  def created_at_formate
    created_at.strftime("%Y-%m-%d %H:%M:%S")
  end

  def hide!
    self.is_hidden = true
    save
  end

  def publish!
    self.is_hidden = false
    save
  end

  def close!
    self.status = "closed"
    save
  end

  def reopen!
    self.status = "open"
    save
  end

  def invitation!(users)
    invitated_users << users
  end

  def cancel_invitation!(users)
    invitated_users.delete(users)
  end

  def watches_counter!
    self.watches += 1
    save
  end

  def pay!
    self.is_paid = true
    save
  end

end

# == Schema Information
#
# Table name: questions
#
#  id             :integer          not null, primary key
#  title          :string
#  description    :text
#  vote           :integer
#  is_hidden      :boolean          default(FALSE)
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  downpayment    :float            default(0.0)
#  status         :string           default("open")
#  tag            :string
#  likes          :integer          default(0)
#  watches        :integer          default(0)
#  payment_method :string
#  is_paid        :boolean          default(FALSE)
#  created_on     :date
#  updated_on     :date
#  answers_count  :integer          default(0)
#
# Indexes
#
#  index_questions_on_user_id  (user_id)
#
