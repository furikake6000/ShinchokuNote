class User < ApplicationRecord
  validates :twitter_id, presence: true

  has_many :notes

  # adminかどうかを返す
  def admin?
    permission == 'admin'
  end

  # 暗号化時のSaltとして使用するバイト列の生成
  def salt_8byte
    # Created_atをSHA256でハッシュ化した最初の7バイト
    OpenSSL::Digest::SHA256.digest(created_at.to_s)[0..7]
  end
end
