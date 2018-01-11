module ApplicationHelper

  #秘密鍵暗号方式（AES-256-CBC）でデータを暗号化する
  #引用元（http://webos-goodies.jp/archives/encryption_in_ruby.html）
  #暗号化
  def encrypt_data(data, password, salt)
    cipher = OpenSSL::Cipher::Cipher.new("AES-256-CBC")
    cipher.encrypt
    cipher.pkcs5_keyivgen(password, salt)
    cipher.update(data) + cipher.final
  end
  #復号化
  def decrypt_data(data, password, salt)
    cipher = OpenSSL::Cipher::Cipher.new("AES-256-CBC")
    cipher.decrypt
    cipher.pkcs5_keyivgen(password, salt)
    s = cipher.update(data) + cipher.final
    #このままだとASCII-8bit形式なので、日本語用にUTF-8に変更
    s.to_s.force_encoding("utf-8")
  end

  #Twitterのサムネイルの原寸バージョンを取得する
  def get_fullsize_thumb_uri(thumb_url)
    thumb_url.to_s.sub(/http/, "https").sub(/(.*)_normal/){$1}
  end

  #404ページ
  def render_404(e = nil)
    render file: Rails.root.join('public/404.html'), status: 404
  end

end
