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
           foreign_key: 'from_user_id'

  has_many :watchlists,
           class_name: 'Watchlist',
           foreign_key: 'from_user_id',
           dependent: :destroy

  has_many :watching_notes,
           through: :watchlists

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

  private
  # 初期化
  def set_default_value
    self.checked_notifications_at = Time.now
  end
end
