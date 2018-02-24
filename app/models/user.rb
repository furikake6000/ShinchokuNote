class User < ApplicationRecord
  validates :twitter_id, presence: true
  validates :twitter_id, uniqueness: true

  has_many :notes

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
end
