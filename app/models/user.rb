# == Schema Information
#
# Table name: users
#
#  id                                :integer          not null, primary key
#  twitter_id                        :string
#  name                              :string
#  screen_name                       :string
#  url                               :string
#  thumb_url                         :string
#  desc                              :string
#  user_group_info                   :string
#  permission                        :string           default("")
#  deleted_at                        :datetime
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  checked_notifications_at          :datetime
#  linked_users_info                 :binary
#  saw_notifications_at              :datetime
#  comment_webpush_enabled           :boolean
#  shinchoku_dodeska_webpush_enabled :boolean
#

class User < ApplicationRecord
  after_initialize :set_default_value, if: :new_record?

  acts_as_paranoid

  validates :twitter_id, presence: true
  validates :twitter_id, uniqueness: true
  validates :screen_name, presence: true

  has_many :notes,
           dependent: :destroy

  has_many :comments,
           class_name: 'Comment',
           foreign_key: 'from_user_id',
           dependent: :destroy

  has_many :watchlists,
           class_name: 'Watchlist',
           foreign_key: 'from_user_id',
           dependent: :destroy

  has_many :watching_notes,
           through: :watchlists,
           dependent: :destroy

  has_many :devices, dependent: :destroy

  has_many :user_blocks, dependent: :destroy

  has_many :blocking_users,
           through: :user_blocks

  # adminかどうかを返す
  def admin?
    permission == 'admin'
  end

  # 暗号化時のSaltとして使用するバイト列の生成
  def salt
    # Created_atをとりあえずsaltとして使用
    created_at.to_s
    # ハッシュ化はencrypt関数がやってくれる
  end

  # 「最新情報」を持ってくるときに基準となる時間
  def notify_from
    # saw_notifications_atがnilの場合はchecked_notifications_at
    self.saw_notifications_at || self.checked_notifications_at
  end
  
  private
  # 初期化
  def set_default_value
    self.checked_notifications_at = Time.now
    self.saw_notifications_at = Time.now
  end
end
