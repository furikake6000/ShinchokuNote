class User < ApplicationRecord
  validates :twitter_id, presence: true

  #このユーザに付随しているユーザ（グループ）を取得
  def get_user_group_info
    #自分がマスタユーザでないとusergroupinfoは取得できない
    raise IsNotMasterUserError if self.twitter_id != master_user_id

    pass = master_user_token

    raise NotImplementedError
  end

  private
    #暗号化時のSaltとして使用するバイト列の生成
    def salt_8byte
      #Created_atをSHA256でハッシュ化した最初の7バイト
      OpenSSL::Digest::SHA256.digest(self.created_at.to_s)[0..7]
    end
end

class IsNotMasterUserError < RuntimeError; end
