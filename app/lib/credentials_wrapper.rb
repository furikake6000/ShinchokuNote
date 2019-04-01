module CredentialsWrapper
  # credentialsを呼ぶラッパーメソッド
  # test環境ではダミー(credentials_dummy.yml)を呼んでくれる
  def credentials_wrap(group, key)
    if Rails.env == 'production' || ENV['USE_CREDENTIALS']
      if key
        Rails.application.credentials.send(group)[key.to_sym]
      else
        Rails.application.credentials.send(group)
      end
    else
      # もし要素が存在しなかったら'dummy'を返す
      if key
        Rails.application.config_for(:credentials_dummy).dig(group, key.to_s) ||
        'dummy'
      else
        Rails.application.config_for(:credentials_dummy).dig(group) ||
        'dummy'
      end
    end
  end
end
